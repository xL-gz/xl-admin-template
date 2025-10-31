<template>
  <a-modal v-model:open="visible" title="个人签名" class="youyi-sign-list-modal" centered :maskClosable="false" :keyboard="false" :width="600">
    <template #closeIcon>
      <ModalClose :canFullscreen="false" @cancel="handleCancel" />
    </template>
    <template #footer>
      <a-button @click="handleCancel">{{ t('common.cancelText') }}</a-button>
      <a-button type="primary" :loading="confirmLoading" @click="handleSubmit">{{ t('common.okText') }}</a-button>
    </template>
    <div class="sign-list-main">
      <a-row class="sign-list" :gutter="20" v-loading="loading">
        <a-col :span="6" class="sign-item" :key="i" v-for="(item, i) in signList">
          <div :class="item.signImg === activeKey ? 'sign-item-main active' : 'sign-item-main'" @click="activeKey = item.signImg">
            <img :src="item.signImg" alt="" class="sign-img" />
            <div class="icon-checked" v-if="item.signImg === activeKey">
              <check-outlined />
            </div>
          </div>
        </a-col>
      </a-row>
      <youyi-empty v-if="!signList.length" />
    </div>
  </a-modal>
</template>
<script lang="ts" setup>
  // import { getSignList } from '@/api/permission/userSetting'; // 已删除 - 后端无此接口
  // 占位符函数
  const getSignList = () => Promise.resolve({ data: [] });
  import { Modal as AModal } from 'ant-design-vue';
  import { reactive, toRefs } from 'vue';
  import ModalClose from '@/components/Modal/src/components/ModalClose.vue';
  import { useMessage } from '@/hooks/web/useMessage';
  import { useI18n } from '@/hooks/web/useI18n';
  import { CheckOutlined } from '@ant-design/icons-vue';

  interface State {
    visible: boolean;
    confirmLoading: boolean;
    loading: boolean;
    signList: any[];
    activeKey: string;
  }

  const emit = defineEmits(['register', 'confirm']);
  defineExpose({ openModal });
  const { createMessage } = useMessage();
  const { t } = useI18n();
  const state = reactive<State>({
    visible: false,
    confirmLoading: false,
    loading: false,
    signList: [],
    activeKey: '',
  });
  const { visible, confirmLoading, loading, signList, activeKey } = toRefs(state);

  function openModal(val) {
    state.visible = true;
    state.confirmLoading = false;
    state.activeKey = '';
    getList(val);
  }
  function getList(defaultVal) {
    getSignList().then(res => {
      state.signList = res.data || [];
      if (defaultVal && state.signList.length && state.signList.some(item => item.signImg === defaultVal)) state.activeKey = defaultVal;
    });
  }
  function handleCancel() {
    state.visible = false;
  }
  function handleSubmit() {
    if (!state.activeKey) {
      createMessage.warning('请选择签名');
      return;
    }
    const item = state.signList.filter(o => o.signImg === state.activeKey)[0];
    emit('confirm', state.activeKey, item?.id || '');
    handleCancel();
  }
</script>
<style lang="less">
  html[data-theme='dark'] {
    .youyi-sign-list-modal .sign-list .sign-item .sign-item-main {
      background-color: #fff;
    }
  }
  .youyi-sign-list-modal {
    .ant-modal-body {
      padding: 20px !important;
    }
    .sign-list-main {
      height: 300px;
      overflow: hidden auto;
    }
    .sign-list {
      .sign-item {
        margin-bottom: 20px;
        .sign-item-main {
          position: relative;
          height: 80px;
          background-color: @app-content-background;
          border-radius: 6px;
          display: flex;
          justify-content: center;
          align-items: center;
          cursor: pointer;
          overflow: hidden;
          .icon-checked {
            display: block;
            width: 16px;
            height: 16px;
            border: 16px solid @primary-color;
            border-left: 16px solid transparent !important;
            border-top: 16px solid transparent !important;
            border-bottom-right-radius: 6px;
            position: absolute;
            right: -1px;
            bottom: -1px;
            .anticon-check {
              position: absolute;
              top: -1px;
              left: -1px;
              font-size: 14px;
              color: #fff;
            }
          }
          &.active {
            border: 1px solid @primary-color;
            box-shadow: 0 0 6px rgba(6, 58, 108, 0.26);
            color: @primary-color;
          }
          &:hover {
            .add-button {
              display: flex;
              width: 100%;
              height: 100%;
              border-radius: 10px;
              background-color: rgba(157, 158, 159, 0.8);
              justify-content: center;
              align-items: center;
            }
          }
          .add-button {
            position: absolute;
            display: none;
          }
          .add-icon {
            font-size: 50px;
            color: @text-color-secondary;
          }
          .sign-img {
            width: 100%;
            height: 100%;
          }
        }
      }
    }
  }
</style>
