<template>
  <div class="youyi-content-wrapper">
    <div class="youyi-content-wrapper-center">
      <div class="youyi-content-wrapper-content">
        <BasicTable @register="registerTable" :columns="columns">
          <template #tableTitle>
            <a-button type="primary" preIcon="icon-ym icon-ym-btn-add" @click="handleAdd()">
              {{ t('common.addText') }}
            </a-button>
          </template>
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'icon'">
              <i :class="record.icon + ' table-icon'" v-if="record.icon" />
            </template>
            <template v-if="column.key === 'enabledMark'">
              <a-tag :color="record.enabledMark == 1 ? 'success' : 'error'">
                {{ record.enabledMark == 1 ? '启用' : '禁用' }}
              </a-tag>
            </template>
            <template v-if="column.key === 'menuType'">
              {{ getMenuTypeName(record.menuType) }}
            </template>
            <template v-if="column.key === 'action'">
              <TableAction :actions="getTableActions(record)" />
            </template>
          </template>
        </BasicTable>
      </div>
    </div>
    <MenuForm @register="registerForm" @reload="reload" />
  </div>
</template>

<script lang="ts" setup>
  import { BasicTable, useTable, TableAction, BasicColumn, ActionItem } from '@/components/Table';
  import { getMenuList, delMenu } from '@/api/system/menu';
  import { useModal } from '@/components/Modal';
  import { useI18n } from '@/hooks/web/useI18n';
  import { useMessage } from '@/hooks/web/useMessage';
  import MenuForm from './Form.vue';

  defineOptions({ name: 'system-menu-manage' });

  const { t } = useI18n();
  const { createMessage } = useMessage();

  const columns: BasicColumn[] = [
    { title: '菜单名称', dataIndex: 'fullName', width: 200 },
    { title: '菜单编码', dataIndex: 'enCode', width: 150 },
    { title: '图标', dataIndex: 'icon', width: 60, align: 'center' },
    { title: '类型', dataIndex: 'menuType', width: 80, align: 'center' },
    { title: '路由地址', dataIndex: 'urlAddress', width: 200 },
    { title: '组件路径', dataIndex: 'component' },
    { title: '排序', dataIndex: 'sortCode', width: 80, align: 'center' },
    { title: '状态', dataIndex: 'enabledMark', width: 80, align: 'center' },
  ];

  const [registerForm, { openModal: openFormModal }] = useModal();
  const [registerTable, { reload }] = useTable({
    api: (params) => getMenuList({ ...params, systemId: 'admin-system' }),
    columns,
    isTreeTable: true,
    pagination: false,
    useSearchForm: true,
    formConfig: {
      schemas: [
        {
          field: 'keyword',
          label: t('common.keyword'),
          component: 'Input',
          componentProps: {
            placeholder: '请输入菜单名称或编码',
            submitOnPressEnter: true,
          },
          colProps: { span: 6 },
        },
        {
          field: 'menuType',
          label: '菜单类型',
          component: 'Select',
          componentProps: {
            placeholder: '请选择',
            options: [
              { label: '目录', value: 'M' },
              { label: '菜单', value: 'C' },
              { label: '按钮', value: 'F' },
            ],
          },
          colProps: { span: 6 },
        },
        {
          field: 'enabledMark',
          label: '状态',
          component: 'Select',
          componentProps: {
            placeholder: '请选择',
            options: [
              { label: '启用', value: 1 },
              { label: '禁用', value: 0 },
            ],
          },
          colProps: { span: 6 },
        },
      ],
    },
    actionColumn: {
      width: 200,
      title: '操作',
      dataIndex: 'action',
    },
  });

  function getMenuTypeName(type: string) {
    const typeMap = {
      'M': '目录',
      'C': '菜单',
      'F': '按钮',
    };
    return typeMap[type] || '-';
  }

  function getTableActions(record): ActionItem[] {
    return [
      {
        label: '编辑',
        onClick: handleEdit.bind(null, record.id),
      },
      {
        label: '添加子菜单',
        onClick: handleAddChild.bind(null, record.id),
        ifShow: record.menuType !== 'F', // 按钮不能添加子菜单
      },
      {
        label: '删除',
        color: 'error',
        popConfirm: {
          title: '确定删除该菜单吗？',
          confirm: handleDelete.bind(null, record.id),
        },
      },
    ];
  }

  function handleAdd() {
    openFormModal(true, { parentId: 0 });
  }

  function handleEdit(id: number) {
    openFormModal(true, { id });
  }

  function handleAddChild(parentId: number) {
    openFormModal(true, { parentId });
  }

  function handleDelete(id: number) {
    delMenu(id).then(res => {
      createMessage.success(res.msg || '删除成功');
      reload();
    });
  }
</script>


