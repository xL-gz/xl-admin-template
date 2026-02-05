<template>
  <div class="youyi-content-wrapper">
    <div class="youyi-content-wrapper-center">
      <div class="youyi-content-wrapper-content">


        <BasicTable @register="registerTable">
          <template #tableTitle>
            <a-button type="primary" preIcon="icon-ym icon-ym-btn-add" @click="addOrUpdateHandle()">
              {{ t('common.addText') }}
            </a-button>
          </template>
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'icon'">
              <i :class="record.icon + ' table-icon'" />
            </template>
            <template v-if="column.key === 'enabledMark'">
              <a-tag :color="record.enabledMark == 1 ? 'success' : 'error'">{{ record.enabledMark == 1 ? '启用' : '禁用' }}</a-tag>
            </template>
            <template v-if="column.key === 'isMain'">
              <a-tag :color="record.isMain == 1 ? 'processing' : 'default'">
                {{ record.isMain == 1 ? '主系统' : '子系统' }}
              </a-tag>
            </template>
            <template v-if="column.key === 'action'">
              <TableAction :actions="getTableActions(record)" :dropDownActions="getDropDownActions(record)" />
            </template>
          </template>
        </BasicTable>
      </div>
    </div>
    <Form @register="registerForm" @reload="reload" />
    <Menu @register="registerMenu" />
    <Portal @register="registerPortal" />
  </div>
</template>
<script lang="ts" setup>
  import { ref } from 'vue';
  import { BasicTable, useTable, TableAction, BasicColumn, ActionItem } from '@/components/Table';
  import { BasicModal } from '@/components/Modal';
  import { getSystemList, delSystem } from '@/api/system/system';
  import { useModal } from '@/components/Modal';
  import { useI18n } from '@/hooks/web/useI18n';
  import { useMessage } from '@/hooks/web/useMessage';
  import { usePopup } from '@/components/Popup';
  import Form from './Form.vue';
  import Menu from './components/menu/index.vue';
  import Portal from './components/portal/index.vue';

  defineOptions({ name: 'system-menu' });

  const { t } = useI18n();
  const { createMessage } = useMessage();
  
  const columns: BasicColumn[] = [
    { title: '应用名称', dataIndex: 'fullName', width: 200 },
    { title: '应用编码', dataIndex: 'enCode', width: 200 },
    { title: '说明', dataIndex: 'description' },
    { title: '类型', dataIndex: 'isMain', width: 80, align: 'center' },
    { title: '图标', dataIndex: 'icon', width: 50, align: 'center' },
    { title: '排序', dataIndex: 'sortCode', width: 70, align: 'center' },
    { title: '状态', dataIndex: 'enabledMark', width: 70, align: 'center' },
  ];
  const [registerForm, { openModal: openFormModal }] = useModal();
  const [registerMenu, { openPopup: openMenuPopup }] = usePopup();
  const [registerPortal, { openPopup: openPortalPopup }] = usePopup();
  const [registerTable, { reload }] = useTable({
    api: getSystemList,
    columns,
    useSearchForm: true,
    pagination: false,
    formConfig: {
      schemas: [
        {
          field: 'keyword',
          label: t('common.keyword'),
          component: 'Input',
          componentProps: {
            placeholder: t('common.enterKeyword'),
            submitOnPressEnter: true,
          },
        },
        {
          field: 'enabledMark',
          label: '状态',
          component: 'Select',
          componentProps: {
            placeholder: '请选择',
            options: [
              { fullName: '启用', id: 1 },
              { fullName: '禁用', id: 0 },
            ],
          },
        },
      ],
    },
    actionColumn: {
      width: 150,
      title: '操作',
      dataIndex: 'action',
    },
  });

  function getTableActions(record): ActionItem[] {
    return [
      {
        label: '菜单管理',  // 把菜单管理放到主要操作按钮中
        onClick: handleMenu.bind(null, record),
        color: 'success',
      },
      {
        label: t('common.editText'),
        onClick: addOrUpdateHandle.bind(null, record.id),
      },
    ];
  }
  function getDropDownActions(record): ActionItem[] {
    return [
      {
        label: t('common.delText'),
        color: 'error',
        disabled: record.isMain == 1,
        popConfirm: {  // 使用 popConfirm 而不是 modelConfirm
          title: '确定删除该应用系统吗？',
          confirm: handleDelete.bind(null, record.id),
        },
      },
      {
        ifShow: !record.isMain,  // 只有非主系统才显示门户管理
        label: '门户管理',
        onClick: handlePortal.bind(null, record),
      },
    ];
  }
  function addOrUpdateHandle(id = '') {
    openFormModal(true, { id });
  }
  function handleMenu(record) {
    openMenuPopup(true, { id: record.id, title: record.fullName, isDevPlatform: !!record.isMain });  // 修复：使用 isMain
  }
  function handlePortal(record) {
    openPortalPopup(true, { id: record.id, title: record.fullName });
  }
  function handleDelete(id) {
    delSystem(id).then(res => {
      createMessage.success(res.msg || res.message || '删除成功');
      reload();
    }).catch((error) => {
      // axios 拦截器已经处理了错误提示（在 transformResponseHook 中），这里只做错误捕获
      // 避免重复显示错误提示
      console.error('删除失败:', error);
    });
  }
</script>

<style scoped>
.guide-content {
  padding: 20px;
}
.guide-content ol {
  padding-left: 20px;
}
.guide-content ol li {
  margin-bottom: 8px;
  line-height: 1.8;
}
</style>
