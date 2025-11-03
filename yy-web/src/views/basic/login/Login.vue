<!--
  登录页面
  
  功能说明：
  1. 用户登录界面，支持账号密码登录和二维码登录
  2. 支持深色模式切换
  3. 显示系统Logo和版权信息
  4. 响应式布局（移动端和PC端适配）
  
  路由路径：/login
-->
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
