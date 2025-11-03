<!--
  首页/仪表盘页面
  
  功能说明：
  1. 系统首页，显示数据统计和图表
  2. 包含访问分析、数据概览等信息
  3. 支持滚动容器展示内容
-->
<template>
  <div class="dashboard-container">
    <ScrollContainer class="dashboard-container">
      <Default />
    </ScrollContainer>
  </div>
</template>

<script lang="ts" setup>
  import { ScrollContainer } from '@/components/Container';
  import Default from './Default.vue';
</script>

<style lang="less" scoped>
  .dashboard-container {
    width: 100%;
    height: 100%;
    position: relative;
    border-radius: 8px;
  }
</style>
