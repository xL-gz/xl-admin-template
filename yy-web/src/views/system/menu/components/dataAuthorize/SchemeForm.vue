<template>
  <BasicModal v-bind="$attrs" @register="registerModal" :title="getTitle" showOkBtn @ok="handleSubmit" class="youyi-condition-modal" destroy-on-close>
    <a-form :colon="false" :labelCol="{ style: { width: '0' } }" :model="dataForm" :rules="dataRule" ref="formElRef">
      <a-form-item name="enCode">
        <a-input v-model:value="dataForm.enCode" placeholder="请输入编码" :maxlength="50" />
      </a-form-item>
      <a-form-item name="fullName">
        <a-input v-model:value="dataForm.fullName" placeholder="请输入方案名称" />
      </a-form-item>
      <div class="condition-main condition-main-bordered">
        <div class="mb-10px" v-if="condition.length">
          <youyi-radio v-model:value="dataForm.matchLogic" :options="logicOptions" optionType="button" button-style="solid" />
        </div>
        <div class="condition-item" v-for="(item, index) in condition" :key="index">
          <div class="condition-item-title">
            <div>条件组</div>
            <i class="icon-ym icon-ym-nav-close" @click="delGroup(index)"></i>
          </div>
          <div class="condition-item-content">
            <div class="condition-item-cap">
              以下条件全部执行：
              <youyi-radio v-model:value="item.logic" :options="logicOptions" optionType="button" button-style="solid" size="small" />
            </div>
            <a-row :gutter="8" v-for="(child, childIndex) in item.groups" :key="index + childIndex" class="mb-10px">
              <a-col :span="6">
                <youyi-select v-model:value="child.id" placeholder="请选择字段" allowClear :options="fieldOptions" @change="onFieldChange($event, child)" />
              </a-col>
              <a-col :span="5">
                <youyi-select v-model:value="child.op" placeholder="选择符号" allowClear :options="child.opOptions" @change="onSymbolChange($event, child)" />
              </a-col>
              <a-col :span="12">
                <template v-if="child.conditionText === 'inputNumber'">
                  <youyi-number-range v-model:value="child.value" :disabled="child.disabled" v-if="child.op == 'between'" />
                  <youyi-input-number v-model:value="child.value" :disabled="child.disabled" placeholder="请输入" v-else />
                </template>
                <template v-else-if="child.conditionText === 'datePicker'">
                  <youyi-date-range
                    v-model:value="child.value"
                    :format="child.format"
                    allowClear
                    :disabled="child.disabled"
                    @change="onDateChange($event, child)"
                    v-if="child.op == 'between'" />
                  <youyi-date-picker
                    v-model:value="child.value"
                    :format="child.format"
                    allowClear
                    :disabled="child.disabled"
                    @change="onDateChange($event, child)"
                    v-else />
                </template>
                <template v-else-if="child.conditionText === 'organizeSelect'">
                  <youyi-organize-select
                    v-model:value="child.value"
                    allowClear
                    :multiple="child.multiple"
                    :disabled="child.disabled"
                    @change="(val, data) => onOrganizeChange(child, val, data)" />
                </template>
                <template v-else-if="child.conditionText === 'depSelect'">
                  <youyi-dep-select
                    v-model:value="child.value"
                    allowClear
                    :multiple="child.multiple"
                    :disabled="child.disabled"
                    @change="(val, data) => onConditionObjChange(child, val, data)" />
                </template>
                <template v-else-if="child.conditionText === 'roleSelect'">
                  <youyi-role-select
                    v-model:value="child.value"
                    allowClear
                    :multiple="child.multiple"
                    :disabled="child.disabled"
                    @change="(val, data) => onConditionObjChange(child, val, data)" />
                </template>
                <template v-else-if="child.conditionText === 'groupSelect'">
                  <youyi-group-select
                    v-model:value="child.value"
                    allowClear
                    :multiple="child.multiple"
                    :disabled="child.disabled"
                    @change="(val, data) => onConditionObjChange(child, val, data)" />
                </template>
                <template v-else-if="child.conditionText === 'posSelect'">
                  <youyi-pos-select
                    v-model:value="child.value"
                    allowClear
                    :multiple="child.multiple"
                    :disabled="child.disabled"
                    @change="(val, data) => onConditionObjChange(child, val, data)" />
                </template>
                <template v-else-if="child.conditionText === 'userSelect'">
                  <youyi-user-select
                    v-model:value="child.value"
                    allowClear
                    :multiple="child.multiple"
                    :disabled="child.disabled"
                    @change="(val, data) => onConditionObjChange(child, val, data)" />
                </template>
                <a-input v-model:value="child.value" placeholder="请输入字段值" allowClear :readonly="child.readonly" :disabled="child.disabled" v-else />
              </a-col>
              <a-col :span="1">
                <i class="icon-ym icon-ym-btn-clearn" @click="delItem(index, childIndex)" />
              </a-col>
            </a-row>
            <span class="link-text inline-block" @click="addItem(index)"><i class="icon-ym icon-ym-btn-add text-14px mr-4px"></i>添加条件</span>
          </div>
        </div>
        <span class="link-text inline-block" @click="addGroup()"> <i class="icon-ym icon-ym-btn-add text-14px mr-4px"></i>添加条件组</span>
      </div>
    </a-form>
  </BasicModal>
</template>
<script lang="ts" setup>
  import { computed, reactive, toRefs, toRaw, ref } from 'vue';
  import { BasicModal, useModalInner } from '@/components/Modal';
  // import { createScheme, updateScheme, getSchemeInfo, getDataAuthorizeList } from '@/api/system/dataAuthorize'; // 已删除 - 后端无此接口
  // 占位符函数 - 仅用于展示
  const createScheme = (_?: any) => Promise.resolve({ msg: '操作成功' });
  const updateScheme = (_?: any) => Promise.resolve({ msg: '操作成功' });
  const getSchemeInfo = (_?: any) => Promise.resolve({ data: {} });
  const getDataAuthorizeList = (_?: any) => Promise.resolve({ data: { list: [], pagination: { total: 0 } } });
  import { useMessage } from '@/hooks/web/useMessage';
  import type { FormInstance } from 'ant-design-vue';
  import { isEmpty } from '@/utils/is';
  import { formatToDateTime } from '@/utils/dateUtil';
  import { useI18n } from '@/hooks/web/useI18n';

  interface State {
    dataForm: any;
    dataRule: any;
    condition: any[];
    logicOptions: any[];
    fieldOptions: any[];
    opOptions: any[];
  }

  const systemFieldOptions = [
    { id: 'input', fullName: '任意文本' },
    { id: '@userId', fullName: '当前用户' },
    { id: '@userAndSubordinates', fullName: '当前用户及下属' },
    { id: '@organizeId', fullName: '当前组织' },
    { id: '@organizationAndSuborganization', fullName: '当前组织及子组织' },
    { id: '@branchManageOrganize', fullName: '当前分管组织' },
  ];
  const state = reactive<State>({
    dataForm: {
      id: '',
      moduleId: '',
      enCode: '',
      fullName: '',
      conditionJson: '',
      conditionText: '',
      matchLogic: 'and',
    },
    dataRule: {
      fullName: [{ required: true, message: '必填', trigger: 'blur' }],
      enCode: [{ required: true, message: '必填', trigger: 'blur' }],
    },
    condition: [
      {
        logic: 'and',
        groups: [
          {
            id: '',
            field: '',
            type: '',
            op: '',
            value: '',
            opOptions: [],
          },
        ],
      },
    ],
    logicOptions: [
      { id: 'and', fullName: '且' },
      { id: 'or', fullName: '或' },
    ],
    fieldOptions: [],
    opOptions: [
      { id: '>=', fullName: '大于等于' },
      { id: '>', fullName: '大于' },
      { id: '==', fullName: '等于' },
      { id: '<=', fullName: '小于等于' },
      { id: '<', fullName: '小于' },
      { id: '<>', fullName: '不等于' },
      { id: 'between', fullName: '介于' },
      { id: 'null', fullName: '为空' },
      { id: 'notNull', fullName: '不为空' },
      { id: 'like', fullName: '包含' },
      { id: 'notLike', fullName: '不包含' },
      { id: 'in', fullName: '包含任意一个' },
      { id: 'notIn', fullName: '不包含任意一个' },
    ],
  });
  const { dataForm, dataRule, condition, logicOptions, fieldOptions } = toRefs(state);
  const formElRef = ref<FormInstance>();

  const getTitle = computed(() => (!state.dataForm.id ? t('common.addText') : t('common.editText')));
  const emit = defineEmits(['register', 'reload']);
  const { createMessage } = useMessage();
  const { t } = useI18n();
  const [registerModal, { closeModal, changeLoading, changeOkLoading }] = useModalInner(init);

  function init(data) {
    state.dataForm.enCode = '';
    state.dataForm.fullName = '';
    state.dataForm.matchLogic = 'and';
    setDefault();
    state.dataForm.id = data.id || '';
    state.dataForm.moduleId = data.moduleId || '';
    changeLoading(true);
    getDataAuthorizeList({ moduleId: state.dataForm.moduleId })
      .then(res => {
        state.fieldOptions = res.data.list;
        state.fieldOptions.map(o => {
          o.enCode = o.enCode.replace('_youyi_', '.');
          o.enCode = o.enCode.replace('youyi_', '');
        });
        if (state.dataForm.id) {
          changeLoading(true);
          getSchemeInfo(state.dataForm.id)
            .then(res => {
              state.dataForm = res.data;
              if (res.data.conditionJson) state.condition = res.data.conditionJson ? JSON.parse(res.data.conditionJson) : [];
              for (let i = 0; i < state.condition.length; i++) {
                let groups = state.condition[i].groups;
                for (let j = 0; j < groups.length; j++) {
                  let e = groups[j];
                  let list = state.fieldOptions.filter(o => o.id === groups[j].id);
                  e.opOptions = list.length ? getOptions(list[0]) : [];
                  e.readonly = systemFieldOptions.some(o => o.id === e.conditionText) && e.conditionText !== 'input';
                }
              }
              changeLoading(false);
            })
            .then(() => {
              changeLoading(false);
            });
        } else {
          changeLoading(false);
        }
      })
      .then(() => {
        changeLoading(false);
      });
  }
  async function handleSubmit() {
    try {
      const values = await formElRef?.value?.validate();
      if (!values) return;
      let conditionText = '';
      let conditionValid = true;
      let condition = JSON.parse(JSON.stringify(state.condition));
      outer: for (let i = 0; i < condition.length; i++) {
        let e = condition[i];
        let text = '';
        if (i > 0) text += state.dataForm.matchLogic || 'and';
        text += '【';
        for (let j = 0; j < e.groups.length; j++) {
          let ee = e.groups[j];
          let item = state.fieldOptions.filter(o => o.id === ee.id)[0];
          if (!item) {
            createMessage.warning('方案内条件配置不完整，请检查条件内容');
            conditionValid = false;
            break outer;
          }
          ee.bindTable = item.bindTable;
          if (!ee.field || !ee.id || !ee.op || (!['null', 'notNull'].includes(ee.op) && ((!ee.value && ee.value !== 0) || isEmpty(ee.value)))) {
            createMessage.warning('方案内条件配置不完整，请检查条件内容');
            conditionValid = false;
            break outer;
          }
          delete ee.readonly;
          delete ee.opOptions;
          const valueLabel = ['null', 'notNull'].includes(ee.op) ? '' : ` {${ee.valueLabel || ee.value}}`;
          text += `${j == 0 ? '' : ` ${e.logic} `}{${getFieldText(ee.id)}} {${getOpText(ee.op)}}${valueLabel}`;
        }
        text += '】';
        conditionText += text;
      }
      if (!conditionValid) return;
      changeOkLoading(true);
      state.dataForm.conditionText = conditionText;
      state.dataForm.conditionJson = JSON.stringify(condition);
      const formMethod = state.dataForm.id ? updateScheme : createScheme;
      formMethod(state.dataForm)
        .then(res => {
          createMessage.success(res.msg);
          changeOkLoading(false);
          closeModal();
          emit('reload');
        })
        .catch(() => {
          changeOkLoading(false);
        });
    } catch (_) {}
  }
  function getOpText(val) {
    if (!val) return val;
    let list = state.opOptions.filter(o => o.id == val);
    if (!list.length) return val;
    return list[0].fullName || val;
  }
  function getFieldText(val) {
    if (!val) return val;
    let list = state.fieldOptions.filter(o => o.id == val);
    if (!list.length) return val;
    return list[0].fullName || val;
  }
  function getOptions(fieldItem) {
    let newOpOptions = [];
    let options = fieldItem.conditionSymbol ? fieldItem.conditionSymbol.split(',') : [];
    outer: for (let i = 0; i < options.length; i++) {
      inner: for (let j = 0; j < state.opOptions.length; j++) {
        if (options[i] === state.opOptions[j].id) {
          (newOpOptions as any[]).push(toRaw(state.opOptions[j]));
          break inner;
        }
      }
    }
    return newOpOptions;
  }
  function addItem(index) {
    state.condition[index].groups.push({ id: '', field: '', type: '', op: '', value: '', opOptions: [] });
  }
  function delItem(index, childIndex) {
    state.condition[index].groups.splice(childIndex, 1);
    if (!state.condition[index].groups.length) delGroup(index);
  }
  function delGroup(index) {
    state.condition.splice(index, 1);
  }
  function addGroup() {
    state.condition.push({ logic: 'and', groups: [{ id: '', field: '', type: '', op: '', value: '', opOptions: [] }] });
  }
  function setDefault() {
    state.condition = [{ logic: 'and', groups: [{ id: '', field: '', type: '', op: '', value: '', opOptions: [] }] }];
  }
  function onFieldChange(val, item) {
    if (!val) {
      item.id = '';
      item.field = '';
      item.type = '';
      item.op = '';
      item.value = '';
      item.valueLabel = '';
      item.conditionText = '';
      item.format = '';
      item.childTableKey = '';
      item.opOptions = [];
      item.readonly = false;
      item.disabled = false;
      item.multiple = false;
    } else {
      item.op = '';
      item.value = '';
      item.valueLabel = '';
      item.readonly = false;
      item.disabled = false;
      item.multiple = false;
      let fieldItem = state.fieldOptions.filter(o => o.id === val)[0];
      item.type = fieldItem.type;
      item.field = fieldItem.enCode;
      item.conditionText = fieldItem.conditionText;
      item.format = fieldItem.format;
      item.childTableKey = fieldItem.childTableKey;
      item.opOptions = getOptions(fieldItem);
      item.fieldRule = fieldItem.fieldRule || 0;
      if (systemFieldOptions.some(o => o.id === fieldItem.conditionText) && fieldItem.conditionText !== 'input') {
        item.readonly = true;
        item.value = fieldItem.conditionText;
        item.valueLabel = fieldItem.conditionText;
      }
    }
  }
  function onSymbolChange(val, item) {
    const systemFieldOptions = ['@userId', '@userAndSubordinates', '@organizeId', '@organizationAndSuborganization', '@branchManageOrganize'];
    item.value = systemFieldOptions.includes(item.conditionText) && !['null', 'notNull'].includes(val) ? item.conditionText : undefined;
    item.valueLabel = '';
    item.disabled = ['null', 'notNull'].includes(val);
    item.multiple = ['in', 'notIn'].includes(val);
  }
  function onDateChange(val, item) {
    const format = item.format || 'YYYY-MM-DD HH:mm:ss';
    if (item.op == 'between') {
      if (!val.length) return (item.valueLabel = '');
      const labelList = val.map(o => formatToDateTime(o, format));
      item.valueLabel = labelList.join();
    } else {
      if (!val) return (item.valueLabel = '');
      item.valueLabel = formatToDateTime(val, format);
    }
  }
  function onOrganizeChange(item, val, data) {
    if (!val || !val.length) return (item.valueLabel = '');
    if (item.multiple) {
      let valueLabelList: string[] = [];
      for (let i = 0; i < data.length; i++) {
        const labelList = data[i].map(o => o.fullName);
        valueLabelList.push(labelList.join('/'));
      }
      item.valueLabel = valueLabelList.join();
    } else {
      const labelList = data.map(o => o.fullName);
      item.valueLabel = labelList.join('/');
    }
  }
  function onConditionObjChange(item, val, data) {
    if (!val || !val.length) return (item.valueLabel = '');
    if (item.multiple) {
      const labelList = data.map(o => o.fullName);
      item.valueLabel = labelList.join();
    } else {
      item.valueLabel = data.fullName || '';
    }
  }
</script>
