<template>
  <BasicModal v-bind="$attrs" @register="registerModal" :title="getTitle" @ok="handleSubmit">
    <a-form :colon="false" :labelCol="{ style: { width: '80px' } }" :model="dataForm" :rules="formRules" ref="formElRef">
      <a-form-item label="翻译分类" name="type">
        <a-select v-model:value="dataForm.type" placeholder="请选择">
          <a-select-option :value="0">客户端</a-select-option>
          <a-select-option :value="1">服务端</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="翻译标记" name="enCode">
        <youyi-input v-model:value="dataForm.enCode" placeholder="请输入" />
      </a-form-item>
      <a-form-item :label="item.fullName" :name="item.enCode" v-for="item in categoryList">
        <youyi-input v-model:value="dataForm[item.enCode]" placeholder="请输入" />
      </a-form-item>
    </a-form>
  </BasicModal>
</template>
<script lang="ts" setup>
  import { create, update, getInfo } from '@/api/system/baseLang';
  import { computed, reactive, ref, toRefs } from 'vue';
  import type { FormInstance } from 'ant-design-vue';
  import { BasicModal, useModalInner } from '@/components/Modal';
  import { useMessage } from '@/hooks/web/useMessage';
  import { useI18n } from '@/hooks/web/useI18n';

  interface State {
    dataForm: any;
    formRules: any;
    categoryList: any[];
  }

  const defaultForm = {
    id: '',
    type: 0,
    enCode: '',
    map: {},
  };
  const emit = defineEmits(['register', 'reload']);
  const formElRef = ref<FormInstance>();
  const state = reactive<State>({
    dataForm: {
      id: '',
      type: 0,
      enCode: '',
      map: {},
    },
    formRules: {
      enCode: [
        { required: true, message: '必填', trigger: 'change' },
        { pattern: /^[a-zA-Z][a-zA-Z0-9._-]*$/, message: '只能输入字母、数字、点、横线和下划线，且以字母开头', trigger: 'change' },
      ],
    },
    categoryList: [],
  });
  const { dataForm, formRules, categoryList } = toRefs(state);

  const [registerModal, { closeModal, changeLoading, changeOkLoading }] = useModalInner(init);
  const { createMessage } = useMessage();
  const { t } = useI18n();

  const getTitle = computed(() => (!state.dataForm.id ? t('common.addText') : t('common.editText')));

  function init(data) {
    changeLoading(true);
    changeOkLoading(false);
    state.dataForm = { ...defaultForm };
    formElRef.value?.resetFields();
    state.dataForm.id = data.id;
    state.categoryList = data.categoryList;
    if (state.dataForm.id) {
      getInfo(state.dataForm.id).then(res => {
        state.dataForm = res.data;
        for (let [key, value] of Object.entries(res.data.map || {})) {
          state.dataForm[key] = value;
        }
        changeLoading(false);
      });
    } else {
      changeLoading(false);
    }
  }
  async function handleSubmit() {
    try {
      const values = await formElRef.value?.validate();
      if (!values) return;
      if (!state.dataForm.map) state.dataForm.map = {};
      for (let i = 0; i < state.categoryList.length; i++) {
        state.dataForm.map[state.categoryList[i].enCode] = state.dataForm[state.categoryList[i].enCode] || '';
      }
      const formMethod = state.dataForm.id ? update : create;
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
</script>
