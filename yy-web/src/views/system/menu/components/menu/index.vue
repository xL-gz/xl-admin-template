<template>
  <BasicPopup v-bind="$attrs" @register="registerPopup" :title="title" class="full-popup">

    
    <!-- 当前系统信息 -->
    <a-descriptions 
      size="small" 
      :column="3" 
      bordered
      class="mx-10px mb-10px">
      <a-descriptions-item label="当前应用系统">
        <a-tag color="processing">{{ title.replace('的菜单管理', '') }}</a-tag>
      </a-descriptions-item>
      <a-descriptions-item label="系统ID">
        <a-tag>{{ systemId }}</a-tag>
      </a-descriptions-item>
      <a-descriptions-item label="系统类型">
        <a-tag :color="isDevPlatform ? 'success' : 'default'">
          {{ isDevPlatform ? '开发平台' : '业务平台' }}
        </a-tag>
      </a-descriptions-item>
    </a-descriptions>

    <div class="youyi-content-wrapper-search-box ml-10px mt-10px">
      <BasicForm class="search-form" @register="registerSearchForm" @submit="handleSubmit" @reset="handleReset" />
    </div>
    <a-tabs v-model:activeKey="listQuery.category" class="youyi-content-wrapper-tabs" destroyInactiveTabPane>
      <a-tab-pane key="Web" tab="Web菜单">
        <BasicTable @register="registerWebTable" :columns="menuTableColumns" :searchInfo="getSearchInfo">
          <template #tableTitle>
            <a-button type="primary" preIcon="icon-ym icon-ym-btn-add" @click="addOrUpdateHandle()">{{ t('common.addText') }}</a-button>
            <youyi-upload-btn
              :url="'/api/system/Menu/' + systemId + '/Actions/Import'"
              :data="{ category: listQuery.category, systemId }"
              @on-success="onUploadSuccess"
              accept=".bm"
              type="menu" />
          </template>
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'icon'">
              <i :class="record.icon + ' table-icon'" />
            </template>
            <template v-if="column.key === 'enabledMark'">
              <a-tag :color="record.enabledMark == 1 ? 'success' : 'error'">{{ record.enabledMark == 1 ? '启用' : '禁用' }}</a-tag>
            </template>
            <template v-if="column.key === 'action'">
              <TableAction :actions="getTableActions(record)" :dropDownActions="getDropDownActions(record)" />
            </template>
          </template>
        </BasicTable>
      </a-tab-pane>
      <a-tab-pane key="App" tab="App菜单" v-if="!isDevPlatform">
        <BasicTable @register="registerAppTable" :columns="menuTableColumns" :searchInfo="getSearchInfo">
          <template #tableTitle>
            <a-button type="primary" preIcon="icon-ym icon-ym-btn-add" @click="addOrUpdateHandle()">{{ t('common.addText') }}</a-button>
            <youyi-upload-btn
              :url="'/api/system/Menu/' + systemId + '/Actions/Import'"
              :data="{ category: listQuery.category, systemId }"
              @on-success="onUploadSuccess"
              accept=".bm"
              type="menu" />
          </template>
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'icon'">
              <i :class="record.icon + ' table-icon'" />
            </template>
            <template v-if="column.key === 'enabledMark'">
              <a-tag :color="record.enabledMark == 1 ? 'success' : 'error'">{{ record.enabledMark == 1 ? '启用' : '禁用' }}</a-tag>
            </template>
            <template v-if="column.key === 'action'">
              <TableAction :actions="getTableActions(record)" :dropDownActions="getDropDownActions(record)" />
            </template>
          </template>
        </BasicTable>
      </a-tab-pane>
    </a-tabs>
    <Form @register="registerForm" @reload="reloadTable" />
    <ButtonAuthorizeListDrawer @register="registerButtonAuthorize" />
    <ColumnAuthorizeListDrawer @register="registerColumnAuthorize" />
    <FormAuthorizeListDrawer @register="registerFormAuthorize" />
    <DataAuthorizeListDrawer @register="registerDataAuthorize" />
  </BasicPopup>
  <PermissionPopup @register="registerPermission" />
</template>
<script lang="ts" setup>
  import { computed, reactive, toRefs, nextTick, watch } from 'vue';
  import { BasicPopup, usePopup, usePopupInner } from '@/components/Popup';
  import { useMessage } from '@/hooks/web/useMessage';
  import { BasicForm, useForm } from '@/components/Form';
  import { useI18n } from '@/hooks/web/useI18n';
  import { BasicTable, useTable, TableAction, BasicColumn, ActionItem } from '@/components/Table';
  import { getMenuList, delMenu, exportMenu } from '@/api/system/menu';
  import { useModal } from '@/components/Modal';
  import { downloadByUrl } from '@/utils/file/download';
  import { useDrawer } from '@/components/Drawer';
  import Form from './Form.vue';
  import ButtonAuthorizeListDrawer from '../buttonAuthorize/index.vue';
  import ColumnAuthorizeListDrawer from '../columnAuthorize/index.vue';
  import FormAuthorizeListDrawer from '../formAuthorize/index.vue';
  import DataAuthorizeListDrawer from '../dataAuthorize/index.vue';
  import PermissionPopup from '../permission/index.vue';

  interface State {
    listQuery: any;
    systemId: string;
    title: string;
    parentId: string;
    isDevPlatform: boolean;
  }

  const { createMessage } = useMessage();
  const { t } = useI18n();
  const state = reactive<State>({
    listQuery: {
      category: 'Web',
      keyword: '',
      type: '',
      enabledMark: '',
    },
    systemId: '',
    title: '',
    parentId: '',
    isDevPlatform: false,
  });
  const { listQuery, title, systemId, isDevPlatform } = toRefs(state);

  const getSearchInfo = computed(() => ({
    keyword: state.listQuery.keyword,
    category: state.listQuery.category,
    systemId: state.systemId,
    type: state.listQuery.type,
    enabledMark: state.listQuery.enabledMark,
  }));

  const menuTableColumns: BasicColumn[] = [
    { title: '菜单名称', dataIndex: 'fullName', width: 260 },
    { title: '编码', dataIndex: 'enCode', width: 160 },
    { title: '菜单地址', dataIndex: 'urlAddress' },
    { title: '图标', dataIndex: 'icon', width: 50, align: 'center' },
    {
      title: '类型',
      dataIndex: 'type',
      width: 70,
      align: 'center',
      customRender: ({ record }) => {
        if (record.type === 1) return '目录';
        if (record.type === 2) return '页面';
        if (record.type === 3) return '表单';
        if (record.type === 4) return '字典';
        if (record.type === 5) return '报表';
        if (record.type === 6) return '大屏';
        if (record.type === 7) return '外链';
        if (record.type === 8) return '门户';
        if (record.type === 9) return '流程';
      },
    },
    { title: '排序', dataIndex: 'sortCode', width: 70, align: 'center' },
    { title: '状态', dataIndex: 'enabledMark', width: 70, align: 'center' },
  ];
  const [registerPopup] = usePopupInner(init);
  const [registerSearchForm, { resetFields }] = useForm({
    baseColProps: { span: 6 },
    showActionButtonGroup: true,
    showAdvancedButton: true,
    compact: true,
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
        field: 'type',
        label: '类型',
        component: 'Select',
        componentProps: {
          placeholder: '请选择',
          options: [
            { fullName: '目录', id: 1 },
            { fullName: '页面', id: 2 },
            { fullName: '表单', id: 3 },
            { fullName: '流程', id: 9 },
            { fullName: '字典', id: 4 },
            { fullName: '报表', id: 5 },
            { fullName: '大屏', id: 6 },
            { fullName: '外链', id: 7 },
            { fullName: '门户', id: 8 },
          ],
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
  });
  const [registerForm, { openModal: openFormModal }] = useModal();
  const [registerWebTable, { reload: reloadWebTable }] = useTable({
    api: getMenuList,
    immediate: false,
    isTreeTable: true,
    pagination: false,
    actionColumn: {
      width: 150,
      title: '操作',
      dataIndex: 'action',
    },
  });
  const [registerAppTable, { reload: reloadAppTable }] = useTable({
    api: getMenuList,
    immediate: false,
    isTreeTable: true,
    pagination: false,
    actionColumn: {
      width: 150,
      title: '操作',
      dataIndex: 'action',
    },
  });
  const [registerButtonAuthorize, { openDrawer: openButtonAuthorizeDrawer }] = useDrawer();
  const [registerColumnAuthorize, { openDrawer: openColumnAuthorizeDrawer }] = useDrawer();
  const [registerFormAuthorize, { openDrawer: openFormAuthorizeDrawer }] = useDrawer();
  const [registerDataAuthorize, { openDrawer: openDataAuthorizeDrawer }] = useDrawer();
  const [registerPermission, { openPopup: openPermissionPopup }] = usePopup();

  watch(
    () => state.listQuery.category,
    () => {
      nextTick(() => resetFields());
    },
    { deep: true },
  );

  function init(data) {
    state.systemId = data.id;
    state.title = data.title + '的菜单管理';
    state.listQuery.category = 'Web';
    state.listQuery.keyword = '';
    state.listQuery.type = '';
    state.listQuery.enabledMark = '';
    state.isDevPlatform = data.isDevPlatform;
    
    console.log('菜单管理初始化 - systemId:', state.systemId);
    console.log('菜单管理初始化 - 是否开发平台:', state.isDevPlatform);
    
    nextTick(() => reloadWebTable({ page: 1 }));
  }
  function getTableActions(record): ActionItem[] {
    return [
      {
        label: t('common.editText'),
        onClick: addOrUpdateHandle.bind(null, record.id, ''),
      },
      {
        label: t('common.delText'),
        color: 'error',
        disabled: record.isMain == 1,
        modelConfirm: {
          onOk: handleDelete.bind(null, record.id),
        },
      },
    ];
  }
  function getDropDownActions(record): ActionItem[] {
    const list = [
      { 
        label: '新建子级', 
        onClick: addOrUpdateHandle.bind(null, '', record.id) 
      }
    ];
    
    if (record?.type == 1) return list;
    
    return [
      ...list,
      {
        label: '按钮权限 🔘',
        ifShow: record.isButtonAuthorize === 1 && [2, 3, 4, 9].indexOf(record.type) > -1,
        onClick: handleButtonAuthorize.bind(null, record),
      },
      {
        label: '列表权限 📋',
        ifShow: record.isColumnAuthorize === 1 && [2, 3, 4, 9].indexOf(record.type) > -1,
        onClick: handleColumnAuthorize.bind(null, record),
      },
      {
        label: '表单权限 📝',
        ifShow: record.isFormAuthorize === 1 && [2, 3, 4].indexOf(record.type) > -1,
        onClick: handleFormAuthorize.bind(null, record),
      },
      {
        label: '数据权限 🗂️',
        ifShow: record.isDataAuthorize === 1 && [2, 3, 4, 9].indexOf(record.type) > -1,
        onClick: handleDataAuthorize.bind(null, record),
      },
      { type: 'divider' },
      {
        label: '导出模板',
        onClick: handleExportMenu.bind(null, record.id),
      },
      {
        label: '查看权限',
        ifShow: ![1, 5, 6, 7, 8].includes(record.type),
        onClick: handlePermission.bind(null, record.id, record.fullName),
      },
    ];
  }
  function handleSubmit(values) {
    state.listQuery.keyword = values?.keyword || '';
    state.listQuery.type = values?.type || '';
    state.listQuery.enabledMark = values?.enabledMark;
    handleSearch();
  }
  function handleReset() {
    state.listQuery.keyword = '';
    state.listQuery.type = '';
    state.listQuery.enabledMark = '';
    handleSearch();
  }
  function handleSearch() {
    nextTick(() => reloadTable());
  }
  function handleDelete(id) {
    delMenu(id).then(res => {
      createMessage.success(res.msg || res.message || '删除成功');
      reloadTable();
    }).catch((error) => {
      // axios 拦截器已经处理了错误提示，这里只做错误捕获
      // 避免重复显示错误提示
      console.error('删除失败:', error);
    });
  }
  function handleButtonAuthorize(record) {
    openButtonAuthorizeDrawer(true, { id: record.id, fullName: record.fullName });
  }
  function handleColumnAuthorize(record) {
    openColumnAuthorizeDrawer(true, { id: record.id, fullName: record.fullName, type: record.type });
  }
  function handleFormAuthorize(record) {
    openFormAuthorizeDrawer(true, { id: record.id, fullName: record.fullName, type: record.type });
  }
  function handleDataAuthorize(record) {
    openDataAuthorizeDrawer(true, { id: record.id, fullName: record.fullName, type: record.type });
  }
  function handleExportMenu(id) {
    exportMenu(id).then(res => {
      downloadByUrl({ url: res.data.url });
    });
  }
  function handlePermission(id, fullName) {
    openPermissionPopup(true, { id, fullName, objectType: 'menu' });
  }
  function addOrUpdateHandle(id = '', parentId = '') {
    openFormModal(true, { id, category: state.listQuery.category, systemId: state.systemId, parentId });
  }
  function onUploadSuccess() {
    reloadTable();
  }
  function reloadTable() {
    state.listQuery.category == 'Web' ? reloadWebTable({ page: 1 }) : reloadAppTable({ page: 1 });
  }
</script>
