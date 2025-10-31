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
      const res = await getMenuSelector();
      menuTreeData.value = buildTreeWithRoot(res.data || []);
    } catch (error) {
      console.error('加载菜单树失败:', error);
    }
  }

  function buildTreeWithRoot(data: any[]) {
    return [
      {
        id: 0,
        fullName: '顶级菜单',
        children: data || [],
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


