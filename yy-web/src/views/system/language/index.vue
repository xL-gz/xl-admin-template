<template>
  <div class="youyi-content-wrapper">
    <div class="youyi-content-wrapper-center">
      <div class="youyi-content-wrapper-content">
        <BasicTable @register="registerTable" :columns="columns">
          <template #tableTitle>
            <a-button type="primary" preIcon="icon-ym icon-ym-btn-add" @click="addOrUpdateHandle()">{{ t('common.addText') }}</a-button>
            <a-button type="link" @click="openImportModal(true, {})">
              <i class="icon-ym icon-ym-btn-upload button-preIcon"></i>{{ t('common.importText') }}
            </a-button>
          </template>
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'action'">
              <TableAction :actions="getTableActions(record)" />
            </template>
          </template>
        </BasicTable>
      </div>
      <Form @register="registerForm" @reload="reload" />
      <ImportModal @register="registerImportModal" @reload="reload" />
    </div>
  </div>
</template>
<script lang="ts" setup>
  import { onMounted, ref } from 'vue';
  import { getBaseLangList, delBaseLang } from '@/api/system/baseLang';
  import { BasicTable, useTable, TableAction, BasicColumn, ActionItem } from '@/components/Table';
  import { useMessage } from '@/hooks/web/useMessage';
  import { useI18n } from '@/hooks/web/useI18n';
  import { useBaseStore } from '@/store/modules/base';
  import { useModal } from '@/components/Modal';
  import Form from './Form.vue';
  import ImportModal from './ImportModal.vue';

  defineOptions({ name: 'commonWords' });

  const baseStore = useBaseStore();
  const { createMessage } = useMessage();
  const { t } = useI18n();
  const [registerForm, { openModal: openFormModal }] = useModal();
  const [registerImportModal, { openModal: openImportModal }] = useModal();
  const categoryList = ref<any[]>([]);
  const columns = ref<BasicColumn[]>([]);
  const typeOptions = [
    { id: 0, fullName: '客户端' },
    { id: 1, fullName: '服务端' },
  ];

  const [registerTable, { reload }] = useTable({
    api: getBaseLangList,
    useSearchForm: true,
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
          field: 'type',
          label: '翻译分类',
          component: 'Select',
          componentProps: { options: typeOptions },
        },
      ],
    },
    actionColumn: {
      width: 100,
      title: '操作',
      dataIndex: 'action',
    },
  });

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
  function addOrUpdateHandle(id = '') {
    openFormModal(true, { id, categoryList: categoryList.value });
  }
  function handleDelete(id) {
    delBaseLang(id).then(res => {
      createMessage.success(res.msg);
      reload();
    });
  }
  async function getColumns() {
    const preList = [
      { title: '翻译标记', dataIndex: 'code' },
      { title: '翻译分类', dataIndex: 'typeName', width: 100 },
    ];
    categoryList.value = (await baseStore.getDictionaryData('Language')) as any[];
    let list: any[] = categoryList.value.map(o => ({ title: o.fullName, dataIndex: o.enCode }));
    columns.value = [...preList, ...list];
  }

  onMounted(() => {
    getColumns();
  });
</script>
