<template>
  <div class="youyi-content-wrapper">
    <div class="youyi-content-wrapper-center">
      <div class="youyi-content-wrapper-content">
        <BasicTable @register="registerTable">
          <template #tableTitle>
            <a-button type="primary" preIcon="icon-ym icon-ym-btn-add" @click="addOrUpdateHandle()">{{ t('common.addText') }}</a-button>
            <a-button type="link" @click="handleExport"><i class="icon-ym icon-ym-btn-download button-preIcon"></i>{{ t('common.exportText') }}</a-button>
            <a-button type="link" @click="handleImport"><i class="icon-ym icon-ym-btn-upload button-preIcon"></i>{{ t('common.importText') }}</a-button>
          </template>
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'enabledMark'">
              <a-tag :color="record.enabledMark === 1 ? 'success' : 'error'">{{ record.enabledMark == 1 ? '启用' : '禁用' }}</a-tag>
            </template>
            <template v-if="column.key === 'action'">
              <TableAction :actions="getTableActions(record)" :dropDownActions="getDropDownActions(record)" />
            </template>
          </template>
        </BasicTable>
      </div>
    </div>
    <Form @register="registerForm" @reload="reload" />
    <Member @register="registerMember" />
    <PermissionPopup @register="registerPermission" />
    <ExportModal @register="registerExportModal" />
    <ImportModal @register="registerImportModal" @reload="reload" />
  </div>
</template>
<script lang="ts" setup>
  import { onMounted } from 'vue';
  import { getPositionList, delPosition } from '@/api/permission/position';
  import { BasicTable, useTable, TableAction, BasicColumn, FormProps, ActionItem } from '@/components/Table';
  import { useMessage } from '@/hooks/web/useMessage';
  import { useI18n } from '@/hooks/web/useI18n';
  import { useModal } from '@/components/Modal';
  import { usePopup } from '@/components/Popup';
  import { useOrganizeStore } from '@/store/modules/organize';
  import Form from './Form.vue';
  import Member from './Member.vue';
  import PermissionPopup from '../organize/Permission.vue';
  import { useBaseStore } from '@/store/modules/base';
  import ImportModal from '@/views/permission/common/components/ImportModal.vue';
  import ExportModal from '@/views/permission/common/components/ExportModal.vue';

  defineOptions({ name: 'permission-position' });

  const { createMessage } = useMessage();
  const { t } = useI18n();
  const baseStore = useBaseStore();
  const organizeStore = useOrganizeStore();
  const [registerMember, { openModal: openMemberModal }] = useModal();
  const [registerForm, { openModal: openFormModal }] = useModal();
  const [registerPermission, { openPopup: openPermissionPopup }] = usePopup();
  const [registerImportModal, { openModal: openImportModal }] = useModal();
  const [registerExportModal, { openModal: openExportModal }] = useModal();

  const columns: BasicColumn[] = [
    { title: '岗位名称', dataIndex: 'fullName', width: 200 },
    { title: '岗位编码', dataIndex: 'enCode', width: 150 },
    { title: '岗位类型', dataIndex: 'type', width: 100 },
    { title: '所属组织', dataIndex: 'department' },
    { title: '创建时间', dataIndex: 'creatorTime', width: 150, format: 'date|YYYY-MM-DD HH:mm:ss' },
    { title: '排序', dataIndex: 'sortCode', width: 70, align: 'center' },
    { title: '状态', dataIndex: 'enabledMark', width: 80, align: 'center' },
  ];
  const [registerTable, { reload, getForm, getFetchParams }] = useTable({
    api: getPositionList,
    beforeFetch: data => {
      data.organizeId = data.organizeTree?.length ? data.organizeTree[data.organizeTree.length - 1] : '';
      delete data.organizeTree;
      return data;
    },
    columns,
    useSearchForm: true,
    formConfig: getFormConfig(),
    actionColumn: {
      width: 150,
      title: '操作',
      dataIndex: 'action',
    },
  });

  function getFormConfig(): Partial<FormProps> {
    return {
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
          field: 'organizeTree',
          label: '所属组织',
          component: 'OrganizeSelect',
          componentProps: {
            placeholder: '请选择',
            auth: true,
          },
        },
        {
          field: 'type',
          label: '岗位类型',
          component: 'Select',
          componentProps: {
            placeholder: '请选择',
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
    };
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
        modelConfirm: {
          onOk: handleDelete.bind(null, record.id),
        },
      },
    ];
  }
  function getDropDownActions(record): ActionItem[] {
    if (!record.enabledMark) return [];
    return [
      {
        label: '岗位成员',
        onClick: viewMember.bind(null, record.id, record.fullName),
      },
      {
        label: '查看权限',
        onClick: handlePermission.bind(null, record.id, record.fullName),
      },
    ];
  }
  function handlePermission(id, fullName) {
    openPermissionPopup(true, { id, fullName, objectType: 'position' });
  }
  async function getTypeOptions() {
    const typeRes = await baseStore.getDictionaryData('PositionType');
    getForm().updateSchema({ field: 'type', componentProps: { options: typeRes } });
  }
  function addOrUpdateHandle(id = '') {
    const values = getForm().getFieldsValue();
    const organizeIdTree = values.organizeTree || [];
    const organizeId = organizeIdTree.length ? organizeIdTree[organizeIdTree.length - 1] : '';
    openFormModal(true, { id, organizeId, organizeIdTree });
  }
  function handleDelete(id) {
    delPosition(id).then(res => {
      createMessage.success(res.msg);
      organizeStore.resetState();
      reload();
    });
  }
  function viewMember(id, fullName) {
    openMemberModal(true, { id, fullName });
  }
  function handleImport() {
    openImportModal(true, { type: 'position' });
  }
  function handleExport() {
    const listQuery = {
      ...getFetchParams(),
      organizeId: getFetchParams().organizeId || '',
      keyword: getFetchParams().keyword || '',
    };
    openExportModal(true, { listQuery, type: 'position' });
  }

  onMounted(() => {
    getTypeOptions();
  });
</script>
