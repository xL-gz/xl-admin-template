<template>
  <BasicModal v-bind="$attrs" @register="registerModal" title="导出" okText="导出" @ok="handleSubmit" destroyOnClose class="export-modal">
    <template #insertFooter>
      <div class="footer-tip">提示:系统将导出列表中选中的数据</div>
    </template>
    <a-form :colon="false" labelAlign="left" :labelCol="{ style: { width: '90px' } }">
      <div class="export-line">
        <p class="export-label">导出方式</p>
      </div>
      <a-form-item>
        <a-radio-group v-model:value="dataType" @change="handleDataTypeChange(dataType)">
          <a-radio :value="item.id" v-for="item in getDataTypeList">{{ item.fullName }}</a-radio>
        </a-radio-group>
      </a-form-item>
      <div class="export-line">
        <p class="export-label">导出数据<span>请选择导出字段</span></p>
      </div>
      <a-checkbox :indeterminate="isIndeterminate" v-model:checked="checkAll" @change="handleCheckAllChange">全选</a-checkbox>
      <a-checkbox-group v-model:value="checkedList" class="options-list" @change="handleCheckedChange">
        <a-checkbox v-for="item in columnList" :key="item.id" :value="item.id" class="options-item">
          {{ item.fullName }}
        </a-checkbox>
      </a-checkbox-group>
    </a-form>
  </BasicModal>
</template>
<script lang="ts" setup>
  import { ref, computed } from 'vue';
  import { BasicModal, useModalInner } from '@/components/Modal';
  import { useMessage } from '@/hooks/web/useMessage';
  import { downloadByUrl } from '@/utils/file/download';
  import { importInfo } from '../helper/config';
  import { cloneDeep } from 'lodash-es';

  const [registerModal, { closeModal, changeOkLoading }] = useModalInner(init);
  const { createMessage } = useMessage();
  const dataType = ref(0);
  const type = ref<string>('user');
  const isIndeterminate = ref(false);
  const checkAll = ref(false);
  const columnList = ref<any[]>([]);
  const checkedList = ref<string[]>([]);
  const defaultCheckedList = ref<string[]>([]);
  const listQuery = ref({});
  const dataTypeList = [
    { fullName: '当前页面数据', id: 0 },
    { fullName: '全部页面数据', id: 1 },
  ];
  const organizeDataTypeListList = [
    { fullName: '公司和部门', id: 0 },
    { fullName: '公司', id: 1 },
    { fullName: '部门', id: 2 },
  ];

  const getDataTypeList = computed(() => (type.value == 'company' ? organizeDataTypeListList : dataTypeList));

  function init(data) {
    type.value = data.type || 'user';
    handleDataTypeChange();
    if (type.value != 'company') columnList.value = importInfo[type.value].exportData.map(o => ({ ...o, fullName: o.title, id: o.dataIndex }));
    dataType.value = 0;
    checkedList.value = columnList.value.map(o => o.id);
    handleCheckedChange(checkedList.value);
    listQuery.value = data.listQuery;
  }
  function handleDataTypeChange(key = 0) {
    if (type.value != 'company') return;
    let list: any = cloneDeep(importInfo.company.exportData[key]);
    columnList.value = list.map(o => ({ ...o, fullName: o.title, id: o.dataIndex }));
    checkedList.value = columnList.value.map(o => o.id);
    handleCheckedChange(checkedList.value);
  }
  function handleCheckAllChange(e) {
    const val = e.target.checked;
    checkedList.value = val ? columnList.value.map(o => o.id) : defaultCheckedList.value;
    isIndeterminate.value = val ? false : !!defaultCheckedList.value.length;
  }
  function handleCheckedChange(val) {
    const checkedCount = val.length;
    checkAll.value = checkedCount === columnList.value.length;
    isIndeterminate.value = !!checkedCount && checkedCount < columnList.value.length;
  }
  function handleSubmit() {
    if (!checkedList.value.length) return createMessage.warning('请至少选择一个导出字段');
    changeOkLoading(true);
    let query = {
      ...listQuery.value,
      dataType: dataType.value,
      selectKey: checkedList.value.join(','),
    };
    importInfo[type.value]
      .exportExcel(query)
      .then(res => {
        changeOkLoading(false);
        if (!res.data.url) return;
        downloadByUrl({ url: res.data.url });
        closeModal();
      })
      .catch(() => {
        changeOkLoading(false);
      });
  }
</script>
