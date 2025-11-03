<!--
  深色模式切换组件
  
  功能说明：
  1. 切换亮色/暗色主题模式
  2. 支持平滑过渡动画
  3. 自动更新头部和侧边栏背景色
  4. 设置信息自动保存
  
  使用位置：系统设置、头部工具栏
-->
<template>
  <div v-if="getShowDarkModeToggle" :class="getClass" @click="toggleDarkMode">
    <div :class="`${prefixCls}-inner`"></div>
    <i class="icon-ym icon-ym-light"></i>
    <i class="icon-ym icon-ym-dark"></i>
  </div>
</template>
<script lang="ts" setup>
  import { computed, unref } from 'vue';
  import { useDesign } from '@/hooks/web/useDesign';
  import { useRootSetting } from '@/hooks/setting/useRootSetting';
  import { updateHeaderBgColor, updateSidebarBgColor } from '@/logics/theme/updateBackground';
  import { updateDarkTheme } from '@/logics/theme/dark';
  import { ThemeEnum } from '@/enums/appEnum';

  const { prefixCls } = useDesign('dark-switch');
  const { getDarkMode, setDarkMode, getShowDarkModeToggle } = useRootSetting();

  const isDark = computed(() => getDarkMode.value === ThemeEnum.DARK);

  const getClass = computed(() => [
    prefixCls,
    {
      [`${prefixCls}--dark`]: unref(isDark),
    },
  ]);

  function toggleDarkMode() {
    const darkMode = getDarkMode.value === ThemeEnum.DARK ? ThemeEnum.LIGHT : ThemeEnum.DARK;
    setDarkMode(darkMode);
    updateDarkTheme(darkMode);
    updateHeaderBgColor();
    updateSidebarBgColor();
  }
</script>
<style lang="less" scoped>
  @prefix-cls: ~'@{namespace}-dark-switch';

  html[data-theme='dark'] {
    .@{prefix-cls} {
      background-color: #151515;
      border: 1px solid rgb(196 188 188);
    }
  }

  .@{prefix-cls} {
    position: relative;
    display: flex;
    width: 56px;
    height: 28px;
    padding: 0 6px;
    cursor: pointer;
    background-color: @primary-color;
    border-radius: 30px;
    justify-content: space-between;
    align-items: center;

    &-inner {
      position: absolute;
      z-index: 1;
      width: 18px;
      height: 18px;
      background-color: #fff;
      border-radius: 50%;
      transition: transform 0.5s, background-color 0.5s;
      will-change: transform;
    }
    .icon-ym {
      font-size: 16px;
      line-height: 28px;
      color: #fff;
    }

    &--dark {
      .@{prefix-cls}-inner {
        transform: translateX(calc(100% + 6px));
      }
    }
  }
</style>
