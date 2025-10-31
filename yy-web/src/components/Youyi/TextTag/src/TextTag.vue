<template>
  <div :class="`${prefixCls} ${prefixCls + '-' + align}`">
    <span class="tag" :style="getTagStyle" v-if="showTag"></span>
    <span class="text" :style="getTextStyle">{{ content }}</span>
  </div>
</template>

<script lang="ts" setup>
  import { computed } from 'vue';
  import { useDesign } from '@/hooks/web/useDesign';

  defineOptions({ name: 'YouyiTextTag', inheritAttrs: false });
  const props = defineProps({
    content: { type: String, default: '' },
    showTag: { type: Boolean, default: true },
    color: { type: String, default: '#1890ff' },
    showTextColor: { type: Boolean, default: false },
    align: { type: String, default: 'center' },
  });
  const { prefixCls } = useDesign('text-tag');

  const getTagStyle = computed(() => ({
    background: props.color,
  }));
  const getTextStyle = computed(() => ({
    color: props.showTextColor ? props.color : '',
  }));
</script>
<style lang="less" scoped>
  @prefix-cls: ~'@{namespace}-text-tag';
  .@{prefix-cls} {
    display: flex;
    align-items: center;
    &&-left {
      justify-content: left;
    }
    &&-center {
      justify-content: center;
    }
    &&-right {
      justify-content: right;
    }
    .tag {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      margin-right: 4px;
    }
  }
</style>
