<template>
  <div :class="prefixCls">

    <div class="flex items-center absolute right-60px top-80px">
      <AppDarkModeToggle class="enter-x" v-if="!sessionTimeout" />
    </div>

    <div class="login-content">
      <div class="login-left hidden xl:block">
        <LoginFormTitle class="-enter-x" />
        <img class="login-banner -enter-x" src="@/assets/images/login-banner.png" alt="" />
      </div>
      <div :class="`${prefixCls}-form`" class="enter-x h-630px xl:h-full">
        <LoginFormTitle class="-enter-x xl:hidden" />
        <LoginForm />
      </div>
    </div>
    <div class="copyright">{{ getSysConfig.copyright }}</div>
  </div>
</template>
<script lang="ts" setup>
  import { computed } from 'vue';
  import { AppDarkModeToggle } from '@/components/Application';
  import LoginFormTitle from './LoginFormTitle.vue';
  import LoginForm from './LoginForm.vue';
  import { useDesign } from '@/hooks/web/useDesign';
  import { useAppStore } from '@/store/modules/app';

  defineProps({
    sessionTimeout: {
      type: Boolean,
    },
  });

  const { prefixCls } = useDesign('login-container');
  const appStore = useAppStore();

  const getSysConfig = computed(() => appStore.getSysConfigInfo);
</script>
<style lang="less">
  @import url('./index.less');
</style>
