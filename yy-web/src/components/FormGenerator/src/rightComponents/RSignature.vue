<template>
  <a-form-item label="选择签章">
    <youyi-select v-model:value="activeData.ableIds" showSearch multiple :options="options" />
  </a-form-item>
</template>
<script lang="ts" setup>
  // import { getSignatureSelector } from '@/api/system/signature'; // 已删除 - 后端无此接口
  import { ref, onMounted } from 'vue';

  defineOptions({ inheritAttrs: false });
  defineProps(['activeData']);

  const options = ref([]);

  function getOptions() {
    // 签章选择器功能已移除
    options.value = [];
  }

  onMounted(() => getOptions());
</script>
