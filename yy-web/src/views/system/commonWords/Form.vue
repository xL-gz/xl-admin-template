<template>
  <BasicModal v-bind="$attrs" @register="registerModal" :title="getTitle" @ok="handleSubmit" @cancel="handleCancel">
    <template #insertFooter>
      <div class="float-left mt-5px" v-if="!id">
        <YouyiCheckboxSingle v-model:value="submitType" label="确定并新增" />
      </div>
    </template>
    <BasicForm @register="registerForm"></BasicForm>
  </BasicModal>
</template>
<script lang="ts" setup>
  import { create, update, getInfo } from '@/api/system/commonWords';
  import { unref, computed, reactive, toRefs } from 'vue';
  import { BasicModal, useModalInner } from '@/components/Modal';
  import { BasicForm, useForm } from '@/components/Form';
  import { useMessage } from '@/hooks/web/useMessage';
  import { useI18n } from '@/hooks/web/useI18n';

  interface State {
    id: string;
    submitType: number;
    commonWordsType: number;
    systemNames: string[];
    isContinue: boolean;
  }

  const emit = defineEmits(['register', 'reload']);

  const state = reactive<State>({
    id: '',
    submitType: 0,
    commonWordsType: 0,
    systemNames: [],
    isContinue: false,
  });
  const { id, submitType } = toRefs(state);
  const [registerForm, { setFieldsValue, resetFields, validate }] = useForm({
    schemas: [
      {
        field: 'commonWordsText',
        label: '常用语',
        component: 'Input',
        componentProps: { placeholder: '请输入', maxlength: 50 },
        rules: [{ required: true, trigger: 'blur', message: '必填' }],
      },
      {
        field: 'sortCode',
        label: '排序',
        defaultValue: 0,
        component: 'InputNumber',
        componentProps: { min: 0, max: 999999 },
        ifShow: ({ values }) => values.commonWordsType === 0,
      },
      {
        field: 'enabledMark',
        label: '状态',
        defaultValue: 1,
        component: 'Switch',
      },
      {
        field: 'commonWordsType',
        label: '类型',
        defaultValue: 0,
        component: 'InputNumber',
        ifShow: false,
      },
    ],
  });
  const [registerModal, { closeModal, changeLoading, changeOkLoading }] = useModalInner(init);
  const { createMessage } = useMessage();
  const { t } = useI18n();

  const getTitle = computed(() => (!unref(id) ? t('common.addText') : t('common.editText')));

  function init(data) {
    state.submitType = 0;
    changeLoading(true);
    changeOkLoading(false);
    state.systemNames = [];
    state.isContinue = false;
    resetFields();
    state.id = data.id;
    if (state.id) {
      getInfo(state.id).then(res => {
        setFieldsValue(res.data);
        state.systemNames = res.data.systemNames || [];
        state.commonWordsType = res.data.commonWordsType || 0;
        changeLoading(false);
      });
    } else {
      setFieldsValue({ commonWordsType: data.commonWordsType || 0 });
      state.commonWordsType = data.commonWordsType || 0;
      changeLoading(false);
    }
  }
  async function handleSubmit() {
    const values = await validate();
    if (!values) return;
    changeOkLoading(true);
    const query = { ...values, id: state.id };
    const formMethod = state.id ? update : create;
    formMethod(query)
      .then(res => {
        createMessage.success(res.msg);
        changeOkLoading(false);
        if (state.submitType == 1) {
          resetFields();
          setFieldsValue({ commonWordsType: state.commonWordsType || 0 });
          state.isContinue = true;
        } else {
          closeModal();
          emit('reload');
        }
      })
      .catch(() => {
        changeOkLoading(false);
      });
  }
  function handleCancel() {
    if (state.isContinue) emit('reload');
  }
</script>
