<template>
  <BasicModal v-bind="$attrs" @register="registerModal" :title="getTitle" showOkBtn @ok="handleSubmit" destroy-on-close>
    <BasicForm @register="registerForm">
      <template #icon="{ model, field }">
        <a-row type="flex">
          <div style="flex: 1; margin-right: 10px">
            <youyi-icon-picker v-model:value="model[field]" placeholder="请选择" />
          </div>
          <a-form-item-rest>
            <youyi-color-picker v-model:value="dataForm.propertyJson.iconBackgroundColor" size="small" :predefine="predefineList" name="iconBackground" />
          </a-form-item-rest>
        </a-row>
      </template>
      <template #urlAddress="{ model, field }">
        <a-input v-model:value="model[field]" placeholder="请输入">
          <template #addonBefore v-if="state.category === 'Web' && model.type == 2">@/views/</template>
          <template #addonAfter v-if="state.category === 'Web' && model.type == 7">
            <a-select v-model:value="dataForm.linkTarget" style="width: 80px">
              <a-select-option value="_self">_self</a-select-option>
              <a-select-option value="_blank">_blank</a-select-option>
            </a-select>
          </template>
        </a-input>
      </template>
      <template #moduleId="{ model, field }">
        <YouyiTreeSelect v-model:value="model[field]" lastLevel :options="tempData" placeholder="请选择关联" @change="onModuleIdChange" :key="moduleIdKey" />
      </template>
    </BasicForm>
  </BasicModal>
</template>
<script lang="ts" setup>
  import { toRefs, computed, reactive, nextTick } from 'vue';
  import { BasicModal, useModalInner } from '@/components/Modal';
  import { BasicForm, useForm, FormSchema } from '@/components/Form';
  import { useMessage } from '@/hooks/web/useMessage';
  import { useBaseStore } from '@/store/modules/base';
  import { getMenuSelector, create, update, getInfo } from '@/api/system/menu';
  // 占位符函数
  const getVisualDevSelector = () => Promise.resolve({ data: { list: [] } });
  const getDictionaryType = () => Promise.resolve({ data: { list: [] } });
  const getDataReportSelector = () => Promise.resolve({ data: { list: [] } });
  const getDataVSelector = () => Promise.resolve({ data: { list: [] } });
  const getPortalSelector = () => Promise.resolve({ data: { list: [] } });
  //import { getTreeList as getFlowSelector } from '@/api/workFlow/template';
  import { useI18n } from '@/hooks/web/useI18n';

  interface State {
    id: string;
    category: string;
    systemId: string;
    dataForm: any;
    featureWebData: any[];
    dictionaryData: any[];
    reportData: any[];
    screenData: any[];
    portalData: any[];
    flowData: any[];
    tempData: any[];
    moduleIdKey: number;
  }

  const predefineList = ['#008cff', '#35b8e0', '#00cc88', '#ff9d00', '#ff4d4d', '#5b69bc', '#ff8acc', '#3b3e47', '#282828'];
  const state = reactive<State>({
    id: '',
    category: '',
    systemId: '',
    dataForm: {
      type: '',
      linkTarget: '',
      propertyJson: {
        moduleId: '',
        iconBackgroundColor: '',
        isTree: 0,
      },
    },
    featureWebData: [],
    dictionaryData: [],
    reportData: [],
    screenData: [],
    portalData: [],
    flowData: [],
    tempData: [],
    moduleIdKey: 0,
  });
  const { dataForm, tempData, moduleIdKey } = toRefs(state);
  const appTypeData: any[] = [
    { id: 1, fullName: '目录' },
    { id: 2, fullName: '页面' },
    { id: 3, fullName: '表单' },
    { id: 9, fullName: '流程' },
    { id: 5, fullName: '报表' },
    { id: 8, fullName: '门户' },
    { id: 7, fullName: '外链' },
  ];
  const typeData: any[] = [
    { id: 1, fullName: '目录' },
    { id: 2, fullName: '页面' },
    { id: 3, fullName: '表单' },
    { id: 9, fullName: '流程' },
    { id: 4, fullName: '字典' },
    { id: 5, fullName: '报表' },
    { id: 6, fullName: '大屏' },
    { id: 8, fullName: '门户' },
    { id: 7, fullName: '外链' },
  ];
  const schemas: FormSchema[] = [
    {
      field: 'parentId',
      label: '上级',
      component: 'TreeSelect',
      componentProps: { placeholder: '请选择', onChange: onParentIdChange },
      rules: [{ required: true, message: '必填', trigger: 'change' }],
    },
    {
      field: 'fullName',
      label: '名称',
      component: 'Input',
      componentProps: { placeholder: '请输入', maxlength: 50 },
      rules: [{ required: true, message: '必填', trigger: 'blur' }],
    },
    {
      field: 'enCode',
      label: '编码',
      component: 'Input',
      componentProps: { placeholder: '请输入', maxlength: 50 },
      rules: [{ required: true, message: '必填', trigger: 'blur' }],
    },
    {
      field: 'icon',
      label: '图标',
      component: 'Input',
      slot: 'icon',
      componentProps: { placeholder: '请选择' },
      rules: [{ required: true, message: '必填', trigger: 'change' }],
    },
    {
      field: 'type',
      label: '类型',
      component: 'Select',
      componentProps: {
        placeholder: '请选择',
        onChange: onTypeChange,
      },
      rules: [{ required: true, trigger: 'change', message: '必填', type: 'number' }],
    },
    {
      ifShow: ({ values }) => values.type == 2 || values.type == 7,
      field: 'urlAddress',
      label: '地址',
      component: 'Input',
      slot: 'urlAddress',
      componentProps: { placeholder: '请输入' },
      rules: [{ required: true, message: '必填', trigger: 'blur' }],
    },
    {
      ifShow: ({ values }) => [3, 4, 5, 6, 8, 9].indexOf(values.type) > -1,
      field: 'moduleId',
      label: '关联',
      component: 'TreeSelect',
      slot: 'moduleId',
      rules: [{ required: true, message: '必填', trigger: 'change' }],
    },
    {
      field: 'sortCode',
      label: '排序',
      component: 'InputNumber',
      defaultValue: 0,
      componentProps: { min: '0', max: '999999', placeholder: '请输入' },
    },
    {
      field: 'enabledMark',
      label: '状态',
      component: 'Switch',
      defaultValue: 1,
    },
    {
      field: 'description',
      label: '说明',
      component: 'Textarea',
      componentProps: { rows: 4, placeholder: '请输入' },
    },
  ];
  const getTitle = computed(() => (!state.id ? t('common.addText') : t('common.editText')));
  const emit = defineEmits(['register', 'reload']);
  const { createMessage } = useMessage();
  const baseStore = useBaseStore();
  const { t } = useI18n();
  const [registerForm, { setFieldsValue, validate, clearValidate, resetFields, updateSchema, getFieldsValue }] = useForm({ labelWidth: 80, schemas: schemas });
  const [registerModal, { closeModal, changeLoading, changeOkLoading }] = useModalInner(init);

  function init(data) {
    resetFields();
    state.id = data.id;
    state.category = data.category;
    state.systemId = data.systemId;
    state.featureWebData = [];
    state.dictionaryData = [];
    state.reportData = [];
    state.screenData = [];
    state.portalData = [];
    state.flowData = [];
    updateSchema({ field: 'type', componentProps: { options: state.category === 'App' ? appTypeData : typeData } });
    getMenuSelectorList(state.category, state.id, state.systemId);
    if (data.parentId) setFieldsValue({ parentId: data.parentId });
    if (state.id) {
      changeLoading(true);
      getInfo(state.id).then(res => {
        const data = res.data;
        const propertyJson = data.propertyJson ? JSON.parse(data.propertyJson) : null;
        data.propertyJson = propertyJson || { moduleId: '', iconBackgroundColor: '' };
        data.moduleId = data.propertyJson.moduleId;
        const menuType = data.type;
        if ([2, 3, 4, 9].includes(menuType)) {
          data.isButtonAuthorize = 1;
          data.isColumnAuthorize = 1;
          data.isFormAuthorize = 1;
          data.isDataAuthorize = 1;
        }
        data.oldUrlAddress = res.data.urlAddress;
        handleHelp(data.type);
        switchType(menuType);
        state.dataForm = data;
        setFieldsValue(data);
        changeLoading(false);
      });
    }
  }
  async function handleSubmit() {
    const values = await validate();
    if (!values) return;

    // 确保编辑模式下有 id
    if (state.id && typeof state.id === 'string' && !state.id.trim()) {
      createMessage.error('菜单ID不存在，无法更新');
      return;
    }

    changeOkLoading(true);
    const menuEnCode = values.enCode.replace('.', '');
    const moduleId = values.moduleId;
    state.dataForm.propertyJson.moduleId = moduleId;
    if (state.category === 'Web') {
      if (values.type == 3 || values.type == 9) values.urlAddress = `model/${menuEnCode}`; // 表单、流程
      if (values.type == 4) values.urlAddress = `dictionary/${menuEnCode}`; // 字典
      if (values.type == 5) values.urlAddress = `dataReport/${menuEnCode}`; // 报表
      if (values.type == 6) values.urlAddress = `dataScreen/${menuEnCode}`; // 大屏
      if (values.type == 8) values.urlAddress = `portal/${menuEnCode}`; // 门户
    } else {
      if (values.type == 3 || values.type == 9) values.urlAddress = `/pages/apply/dynamicModel/index?id=${moduleId}`;
      if (values.type == 5 || values.type == 8) values.urlAddress = menuEnCode;
    }
    // 构建提交数据，确保字段映射正确
    const query: any = {
      fullName: values.fullName,
      enCode: values.enCode,
      icon: values.icon,
      type: values.type,
      sortCode: values.sortCode || 0,
      enabledMark: values.enabledMark !== undefined ? values.enabledMark : 1,
      parentId: values.parentId ? (typeof values.parentId === 'string' && values.parentId === '-1' ? 0 : Number(values.parentId)) : 0,
      systemId: state.systemId,
      category: state.category,
      propertyJson: JSON.stringify(state.dataForm.propertyJson),
      linkTarget: state.dataForm.linkTarget || '_self',
      // description 字段映射到 remark（如果后端MenuDTO支持description，可以去掉这行）
      remark: values.description || state.dataForm.remark || '',
      // 确保 ID 是正确的类型
      id: state.id ? (typeof state.id === 'string' ? Number(state.id) : state.id) : undefined,
    };

    // 只在有地址的时候设置 urlAddress
    if (values.urlAddress) {
      query.urlAddress = values.urlAddress;
    }

    // 如果存在其他字段，也保留
    if (state.dataForm.orderNum !== undefined) {
      query.orderNum = state.dataForm.orderNum;
    }
    if (state.dataForm.visible !== undefined) {
      query.visible = state.dataForm.visible;
    }
    if (state.dataForm.status !== undefined) {
      query.status = state.dataForm.status;
    }
    if (state.dataForm.perms) {
      query.perms = state.dataForm.perms;
    }

    console.log('提交菜单数据:', query);
    console.log('是否为编辑模式:', !!state.id);
    console.log('state.id 值:', state.id);
    console.log('query.id 值:', query.id);

    const formMethod = state.id ? update : create;
    formMethod(query)
      .then(res => {
        console.log('提交成功，响应:', res);
        createMessage.success(res?.msg || res?.message || (state.id ? '更新成功' : '创建成功'));
        changeOkLoading(false);
        emit('reload');
        setTimeout(() => {
          closeModal();
        }, 200);
      })
      .catch(error => {
        console.error('提交失败:', error);
        console.error('错误详情:', {
          message: error?.message,
          response: error?.response,
          data: error?.response?.data,
        });
        changeOkLoading(false);
        // 如果 axios 拦截器没有显示错误，显示一个通用错误
        if (error?.response?.data?.msg) {
          createMessage.error(error.response.data.msg);
        } else if (error?.message) {
          createMessage.error(error.message);
        } else {
          createMessage.error('操作失败，请检查控制台日志');
        }
      });
  }
  function onTypeChange(val) {
    // 重置关联下拉框的值及链接处理
    setFieldsValue({ moduleId: '' });
    clearValidate();
    state.moduleIdKey = +new Date();
    const menuId = state.id;
    if (menuId) {
      state.dataForm.urlAddress = '';
      setFieldsValue({ urlAddress: '' });
    }
    if ([2, 3, 4, 9].includes(val)) {
      state.dataForm.isButtonAuthorize = 1;
      state.dataForm.isColumnAuthorize = 1;
      state.dataForm.isFormAuthorize = 1;
      state.dataForm.isDataAuthorize = 1;
    } else {
      state.dataForm.isButtonAuthorize = 0;
      state.dataForm.isColumnAuthorize = 0;
      state.dataForm.isFormAuthorize = 0;
      state.dataForm.isDataAuthorize = 0;
    }
    if (val == 6) {
      state.dataForm.linkTarget = '_blank';
    } else {
      state.dataForm.linkTarget = '_self';
    }
    handleHelp(val);
    switchType(val);
  }
  function handleHelp(val) {
    updateSchema([{ field: 'urlAddress', helpMessage: val === 7 ? '地址以http://或https://为开头' : '' }]);
  }
  function onParentIdChange(val) {
    if (state.category !== 'App') return;
    const values = getFieldsValue();
    let tempData: any[] = [];
    if (val === '-1') {
      tempData = appTypeData.filter(o => o.id == 1);
      if (values.type && values.type != 1) setFieldsValue({ type: '' });
    } else {
      tempData = appTypeData;
    }
    updateSchema({ field: 'type', componentProps: { options: tempData } });
  }
  function onModuleIdChange(val) {
    const values = getFieldsValue();
    if (values.type == 4) {
      const item = treeToArray(state.dictionaryData).filter(o => (o as any)?.id === val);
      state.dataForm.propertyJson.isTree = (item[0] as any)?.isTree;
    }
  }
  function treeToArray(list, newArr: any = []) {
    list.forEach(item => {
      const { children } = item;
      if (children?.length) {
        newArr.push(item);
        return treeToArray(children, newArr);
      }
      newArr.push(item);
    });
    return newArr;
  }
  function getMenuSelectorList(category, id = '0', systemId) {
    getMenuSelector({ category }, id, systemId).then(res => {
      let topItem = {
        fullName: '顶级节点',
        hasChildren: true,
        id: '-1',
        children: res.data.list,
      };
      updateSchema({ field: 'parentId', componentProps: { options: [topItem] } });
    });
  }
  function switchType(val) {
    if (val == 3) fetchFeatureList();
    if (val == 4) fetchDictionaryType();
    if (val == 5) fetchDataReportList();
    if (val == 6) fetchDataVList();
    if (val == 8) fetchPortalList();
    if (val == 9) fetchFlowList();
  }
  function fetchFeatureList() {
    if (!state.featureWebData.length) {
      getVisualDevSelector({ type: 1, isRelease: 1 }).then(res => {
        state.featureWebData = res.data.list;
        state.tempData = state.featureWebData;
      });
      return;
    }
    state.tempData = state.featureWebData;
  }
  function fetchDictionaryType() {
    if (!state.dictionaryData.length) {
      getDictionaryType().then(res => {
        state.dictionaryData = res.data.list;
        state.tempData = state.dictionaryData;
      });
      return;
    }
    state.tempData = state.dictionaryData;
  }
  async function fetchDataReportList() {
    if (!state.reportData.length) {
      const data = await baseStore.getDictionaryData('businessType');
      const ReportSortTypeList = JSON.parse(JSON.stringify(data));
      getDataReportSelector().then(res => {
        let reportData = res.data.list;
        state.reportData = ReportSortTypeList;
        nextTick(() => {
          for (let i = 0; i < state.reportData.length; i++) {
            let child = reportData.filter(o => state.reportData[i].id === o.categoryId);
            state.reportData[i].children = child;
            state.reportData[i].hasChildren = !!child?.length;
          }
          state.reportData = state.reportData.filter(o => o.children.length);
          state.tempData = state.reportData;
        });
      });
      return;
    }
    state.tempData = state.reportData;
  }
  function fetchDataVList() {
    if (!state.screenData.length) {
      getDataVSelector().then(res => {
        state.screenData = res.data.list;
        state.tempData = state.screenData;
      });
      return;
    }
    state.tempData = state.screenData;
  }
  function fetchPortalList() {
    if (!state.portalData.length) {
      getPortalSelector().then(res => {
        state.portalData = res.data.list.filter(o => o.children && o.children.length);
        state.tempData = state.portalData;
      });
      return;
    }
    state.tempData = state.portalData;
  }
  function fetchFlowList() {
    if (!state.flowData.length) {
      // getFlowSelector('2').then(res => {
      //   state.flowData = res.data.list.filter(o => o.children && o.children.length);
      //   state.tempData = state.flowData;
      // });
      return;
    }
    state.tempData = state.flowData;
  }
</script>
