<!--
  应用根组件
  功能说明：
  1. 全局主题配置：支持亮色/暗色模式切换
  2. 多语言配置：集成Ant Design国际化
  3. 动态主题色：根据配置动态切换主题色
  4. 系统背景：支持多种系统背景切换
  5. 路由视图：渲染当前路由对应的页面
-->
<template>
  <ConfigProvider :theme="appTheme" :locale="getAntdLocale">
    <AppProvider>
      <RouterView />
    </AppProvider>
  </ConfigProvider>
</template>

<script lang="ts" setup>
  import { watch, watchEffect, ref, computed, unref } from 'vue';
  import { theme } from 'ant-design-vue';
  import { ConfigProvider } from 'ant-design-vue';
  import { AppProvider } from '@/components/Application';
  import { useTitle } from '@/hooks/web/useTitle';
  import { useLocale } from '@/locales/useLocale';
  import { useAppStore } from '@/store/modules/app';
  import { useRootSetting } from '@/hooks/setting/useRootSetting';
  import { ThemeEnum } from '@/enums/appEnum';
  import { changeTheme } from '@/logics/theme/index';
  import { primaryColor } from '../build/config/themeConfig';

  const appStore = useAppStore();
  // support Multi-language
  const { getAntdLocale } = useLocale();

  // Listening to page changes and dynamically changing site titles
  useTitle();
  const appTheme: any = ref({});
  const { getDarkMode } = useRootSetting();

  const getThemeColor = computed(() => appStore.getProjectConfig.themeColor);
  const getGlobalBorderRadius = computed(() => appStore.getProjectConfig.globalBorderRadius);
  const getSysBg = computed(() => appStore.getProjectConfig.sysBg);
  const htmlRoot: any = document.getElementById('htmlRoot');

  watch(
    () => getDarkMode.value,
    () => {
      changeAppTheme();
    },
    { immediate: true },
  );
  watch(
    getThemeColor,
    () => {
      changeAppTheme();
    },
    { immediate: true },
  );
  watchEffect(() => {
    htmlRoot.setAttribute('data-bg', unref(getSysBg) || 'default');
  });

  function changeAppTheme() {
    delete appTheme.value.algorithm;
    let colorPrimary = primaryColor;
    if (getDarkMode.value === ThemeEnum.DARK) {
      appTheme.value.algorithm = theme.darkAlgorithm;
      colorPrimary = primaryColor;
    } else {
      colorPrimary = getThemeColor.value;
    }
    appTheme.value = {
      ...appTheme.value,
      ...{
        token: {
          colorPrimary: colorPrimary,
          colorSuccess: '#55D187',
          colorInfo: colorPrimary,
          colorWarning: '#EFBD47',
          colorError: '#ED6F6F',
          wireframe: true,
          borderRadius: unref(getGlobalBorderRadius),
          sizeStep: 4,
          sizeUnit: 4,
        },
      },
    };
  }

  setTimeout(() => {
    appStore.getProjectConfig?.themeColor && changeTheme(appStore.getProjectConfig.themeColor);
  }, 300);

  htmlRoot.style.setProperty('--border-radius', unref(getGlobalBorderRadius) + 'px');

  // 阻止火狐浏览器在拖动时打开新窗口
  document.body.ondrop = function (event) {
    event.preventDefault();
    event.stopPropagation();
  };
</script>
