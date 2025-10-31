<template>
  <BasicDrawer v-bind="$attrs" @register="registerDrawer" :title="title" :width="700" class="full-drawer">
    <BasicTable @register="registerTable">
      <template #tableTitle>
        <a-button type="primary" preIcon="icon-ym icon-ym-btn-add" @click="addOrUpdateHandle()">{{ t('common.addText') }}</a-button>
        <a-dropdown>
          <template #overlay>
            <a-menu>
              <a-menu-item v-for="(item, i) in btnList" :key="i" @click="handleAdd(item)">{{ item.fullName }}</a-menu-item>
            </a-menu>
          </template>
          <a-button type="link" :loading="loading" preIcon="icon-ym icon-ym-btn-add">常用按钮权限<DownOutlined /></a-button>
        </a-dropdown>
      </template>
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'enabledMark'">
          <a-tag :color="record.enabledMark == 1 ? 'success' : 'error'">{{ record.enabledMark == 1 ? '启用' : '禁用' }}</a-tag>
        </template>
        <template v-if="column.key === 'action'">
          <TableAction :actions="getTableActions(record)" />
        </template>
      </template>
    </BasicTable>
  </BasicDrawer>
  <Form @register="registerForm" @reload="reload" />
</template>
<script lang="ts" setup>
  // 已删除API - 使用静态数据展示
  import { reactive, toRefs, nextTick, ref } from 'vue';
  import { BasicDrawer, useDrawerInner } from '@/components/Drawer';
  import { BasicTable, useTable, TableAction, BasicColumn, ActionItem } from '@/components/Table';
  import { useModal } from '@/components/Modal';
  import { useMessage } from '@/hooks/web/useMessage';
  import { useI18n } from '@/hooks/web/useI18n';
  import { DownOutlined } from '@ant-design/icons-vue';
  import Form from './Form.vue';

  interface State {
    id: string;
    title: string;
    loading: boolean;
  }

  const state = reactive<State>({
    id: '',
    title: '',
    loading: false,
  });
  const { title, loading } = toRefs(state);
  const { createMessage } = useMessage();
  const { t } = useI18n();
  const [registerDrawer, {}] = useDrawerInner(init);
  const [registerForm, { openModal: openFormModal }] = useModal();
  const btnList = [
    { fullName: '新增', id: 'btn_add' },
    { fullName: '编辑', id: 'btn_edit' },
    { fullName: '详情', id: 'btn_detail' },
    { fullName: '删除', id: 'btn_remove' },
    { fullName: '批量删除', id: 'btn_batchRemove' },
    { fullName: '批量打印', id: 'btn_batchPrint' },
    { fullName: '复制', id: 'btn_copy' },
    { fullName: '导入', id: 'btn_upload' },
    { fullName: '导出', id: 'btn_download' },
  ];
  const columns: BasicColumn[] = [
    { title: '按钮名称', dataIndex: 'fullName', width: 160 },
    { title: '按钮编码', dataIndex: 'enCode' },
    { title: '排序', dataIndex: 'sortCode', width: 70, align: 'center' },
    { title: '状态', dataIndex: 'enabledMark', width: 70, align: 'center' },
  ];
  // 使用静态数据源，不调用API
  const staticData = ref<any[]>([]);
  const [registerTable, { reload, setTableData }] = useTable({
    dataSource: staticData,
    columns,
    pagination: false,
    immediate: false,
    showIndexColumn: false,
    actionColumn: {
      width: 100,
      title: '操作',
      dataIndex: 'action',
    },
  });

  function init(data) {
    state.id = data.id;
    state.title = `按钮权限 - ${data.fullName}`;
    // 已删除API - 使用空数组
    staticData.value = [];
    nextTick(() => {
      setTableData(staticData.value);
    });
  }
  function getTableActions(record): ActionItem[] {
    return [
      {
        label: t('common.editText'),
        onClick: addOrUpdateHandle.bind(null, record.id),
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
  function handleDelete(id) {
    // 已删除API - 仅显示提示
    createMessage.success('操作成功');
    const index = staticData.value.findIndex(item => item.id === id);
    if (index > -1) {
      staticData.value.splice(index, 1);
      setTableData(staticData.value);
    }
  }
  function addOrUpdateHandle(id = '') {
    openFormModal(true, { moduleId: state.id, id });
  }
  function handleAdd(item) {
    // 已删除API - 仅显示提示
    state.loading = true;
    const newItem = {
      id: Date.now().toString(),
      parentId: '-1',
      moduleId: state.id,
      fullName: item.fullName,
      enCode: item.id,
      sortCode: 0,
      icon: '',
      enabledMark: 1,
      description: '',
      isMain: 0,
    };
    staticData.value.push(newItem);
    setTableData(staticData.value);
    createMessage.success('操作成功');
    state.loading = false;
  }
</script>
