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
