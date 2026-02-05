<template>
  <BasicModal v-bind="$attrs" @register="registerModal" :title="getTitle" width="800px" @ok="handleSubmit">
    <BasicForm @register="registerForm" />
  </BasicModal>
</template>

<script lang="ts" setup>
  import { ref, computed, unref } from 'vue';
  import { BasicModal, useModalInner } from '@/components/Modal';
  import { BasicForm, useForm, FormSchema } from '@/components/Form';
  import { create, update, getInfo, getMenuSelector } from '@/api/system/menu';
  import { useMessage } from '@/hooks/web/useMessage';

  const emit = defineEmits(['reload', 'register']);
  const { createMessage } = useMessage();
  const id = ref('');
  const menuTreeData = ref<any[]>([]);

  const schemas: FormSchema[] = [
    {
      field: 'parentId',
      label: '上级菜单',
      component: 'TreeSelect',
      componentProps: {
        placeholder: '请选择上级菜单（不选则为顶级菜单）',
        treeData: menuTreeData,
        fieldNames: {
          label: 'fullName',
          value: 'id',
          children: 'children',
        },
        getPopupContainer: () => document.body,
      },
      defaultValue: 0,
    },
    {
      field: 'menuType',
      label: '菜单类型',
      component: 'RadioButtonGroup',
      componentProps: {
        options: [
          { label: '目录', value: 'M' },
          { label: '菜单', value: 'C' },
          { label: '按钮', value: 'F' },
        ],
      },
      defaultValue: 'C',
      required: true,
    },
    {
      field: 'menuName',
      label: '菜单名称',
      component: 'Input',
      componentProps: {
        placeholder: '请输入菜单名称',
        maxlength: 50,
      },
      required: true,
    },
    {
      field: 'fullName',
      label: '菜单全称',
      component: 'Input',
      componentProps: {
        placeholder: '请输入菜单全称',
        maxlength: 100,
      },
      required: true,
    },
    {
      field: 'enCode',
      label: '菜单编码',
      component: 'Input',
      componentProps: {
        placeholder: '请输入菜单编码（英文）',
        maxlength: 50,
      },
      required: true,
    },
    {
      field: 'icon',
      label: '菜单图标',
      component: 'Input',
      componentProps: {
        placeholder: '请输入图标类名',
      },
      ifShow: ({ values }) => values.menuType !== 'F',
    },
    {
      field: 'path',
      label: '路由地址',
      component: 'Input',
      componentProps: {
        placeholder: '请输入路由地址，如：/system/user',
      },
      ifShow: ({ values }) => values.menuType !== 'F',
    },
    {
      field: 'urlAddress',
      label: '菜单地址',
      component: 'Input',
      componentProps: {
        placeholder: '请输入菜单地址',
      },
      ifShow: ({ values }) => values.menuType !== 'F',
    },
    {
      field: 'component',
      label: '组件路径',
      component: 'Input',
      componentProps: {
        placeholder: '请输入组件路径，如：system/user/index',
      },
      ifShow: ({ values }) => values.menuType === 'C',
    },
    {
      field: 'perms',
      label: '权限标识',
      component: 'Input',
      componentProps: {
        placeholder: '请输入权限标识，如：system:user:view',
      },
    },
    {
      field: 'sortCode',
      label: '排序',
      component: 'InputNumber',
      componentProps: {
        placeholder: '请输入排序号',
        min: 0,
        max: 9999,
      },
      defaultValue: 0,
    },
    {
      field: 'visible',
      label: '是否显示',
      component: 'RadioButtonGroup',
      componentProps: {
        options: [
          { label: '显示', value: '0' },
          { label: '隐藏', value: '1' },
        ],
      },
      defaultValue: '0',
      ifShow: ({ values }) => values.menuType !== 'F',
    },
    {
      field: 'status',
      label: '菜单状态',
      component: 'RadioButtonGroup',
      componentProps: {
        options: [
          { label: '正常', value: '0' },
          { label: '停用', value: '1' },
        ],
      },
      defaultValue: '0',
    },
    {
      field: 'enabledMark',
      label: '启用状态',
      component: 'RadioButtonGroup',
      componentProps: {
        options: [
          { label: '启用', value: 1 },
          { label: '禁用', value: 0 },
        ],
      },
      defaultValue: 1,
    },
    {
      field: 'isFrame',
      label: '是否外链',
      component: 'RadioButtonGroup',
      componentProps: {
        options: [
          { label: '是', value: 0 },
          { label: '否', value: 1 },
        ],
      },
      defaultValue: 1,
      ifShow: ({ values }) => values.menuType !== 'F',
    },
    {
      field: 'isCache',
      label: '是否缓存',
      component: 'RadioButtonGroup',
      componentProps: {
        options: [
          { label: '缓存', value: 0 },
          { label: '不缓存', value: 1 },
        ],
      },
      defaultValue: 0,
      ifShow: ({ values }) => values.menuType === 'C',
    },
    {
      field: 'remark',
      label: '备注',
      component: 'InputTextArea',
      componentProps: {
        placeholder: '请输入备注',
        rows: 3,
        maxlength: 500,
      },
    },
  ];

  const [registerForm, { resetFields, setFieldsValue, validate }] = useForm({
    labelWidth: 100,
    schemas,
    showActionButtonGroup: false,
    baseColProps: { span: 24 },
  });

  const [registerModal, { setModalProps, closeModal }] = useModalInner(async (data) => {
    resetFields();
    setModalProps({ confirmLoading: false });
    
    // 加载菜单树
    await loadMenuTree();
    
    id.value = data?.id || '';
    
    if (data?.parentId) {
      setFieldsValue({ parentId: data.parentId });
    }
    
    if (unref(id)) {
      // 编辑模式
      setModalProps({ confirmLoading: true });
      getInfo(unref(id)).then(res => {
        setFieldsValue(res.data);
        setModalProps({ confirmLoading: false });
      });
    }
  });

  const getTitle = computed(() => (!unref(id) ? '新增菜单' : '编辑菜单'));

  async function loadMenuTree() {
    try {
      // 使用菜单选择器接口（内部会调用菜单列表接口）
      const res = await getMenuSelector({}, 0, 'admin-system');
      
      if (res && res.data) {
        menuTreeData.value = buildTreeWithRoot(res.data);
      } else {
        // 如果没有数据，提供空的根节点
        menuTreeData.value = [
          {
            id: 0,
            fullName: '顶级菜单',
            children: [],
          },
        ];
      }
    } catch (error) {
      console.error('加载菜单树失败:', error);
      // 如果接口失败，提供一个空的根节点
      menuTreeData.value = [
        {
          id: 0,
          fullName: '顶级菜单',
          children: [],
        },
      ];
    }
  }

  function buildTreeWithRoot(data: any) {
    // 处理数据结构 - 兼容不同的返回格式
    let menuList = [];
    if (Array.isArray(data)) {
      menuList = data;
    } else if (data && Array.isArray(data.list)) {
      menuList = data.list;
    }
    
    // 过滤掉按钮类型，只保留目录和菜单用于上级选择
    const filteredMenus = menuList
      .filter(item => item && item.menuType !== 'F') // 过滤掉按钮类型
      .map(item => ({
        id: item.id,
        fullName: item.fullName,
        parentId: item.parentId || 0,
        children: item.children || [], // 保留原有的children结构
      }));
    
    // 如果数据已经是树形结构，直接使用；否则构建树形结构
    const hasChildren = filteredMenus.some(item => item.children && item.children.length > 0);
    
    let treeData;
    if (hasChildren) {
      // 数据已经是树形结构
      treeData = filteredMenus;
    } else {
      // 需要构建树形结构
      const buildTree = (items, parentId = 0) => {
        return items
          .filter(item => item.parentId === parentId)
          .map(item => ({
            ...item,
            children: buildTree(items, item.id),
          }));
      };
      treeData = buildTree(filteredMenus, 0);
    }
    
    return [
      {
        id: 0,
        fullName: '顶级菜单',
        children: treeData,
      },
    ];
  }

  async function handleSubmit() {
    try {
      const values = await validate();
      setModalProps({ confirmLoading: true });

      // 处理数据
      const data = {
        ...values,
        orderNum: values.sortCode,
        parentId: values.parentId || 0,
        systemId: 'admin-system', // 设置默认的systemId
      };

      if (unref(id)) {
        data.id = unref(id);
        await update(data);
        createMessage.success('修改成功');
      } else {
        await create(data);
        createMessage.success('新增成功');
      }

      closeModal();
      emit('reload');
    } finally {
      setModalProps({ confirmLoading: false });
    }
  }
</script>


