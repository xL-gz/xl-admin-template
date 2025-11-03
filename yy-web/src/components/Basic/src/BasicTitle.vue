<!--
  基础标题组件
  
  功能说明：
  1. 显示文本标题，支持左侧彩色标记条
  2. 支持帮助文本提示（带问号图标）
  3. 支持自定义样式（加粗、普通、显示标记条）
  
  使用示例：
  <BasicTitle span>标题</BasicTitle>
  <BasicTitle :helpMessage="'帮助信息'">标题</BasicTitle>
  <BasicTitle normal>普通标题</BasicTitle>
-->
<template>
  <span :class="getClass">
    <slot></slot>
    <BasicHelp :class="`${prefixCls}-help`" v-if="helpMessage" :text="helpMessage" />
  </span>
</template>
<script lang="ts" setup>
  import type { PropType } from 'vue';
  import { useSlots, computed } from 'vue';
  import BasicHelp from './BasicHelp.vue';
  import { useDesign } from '@/hooks/web/useDesign';

  const props = defineProps({
    /**
     * Help text list or string
     * @default: ''
     */
    helpMessage: {
      type: [String, Array] as PropType<string | string[]>,
      default: '',
    },
    /**
     * Whether the color block on the left side of the title
     * @default: false
     */
    span: { type: Boolean },
    /**
     * Whether to default the text, that is, not bold
     * @default: false
     */
    normal: { type: Boolean },
  });

  const { prefixCls } = useDesign('basic-title');
  const slots = useSlots();
  const getClass = computed(() => [prefixCls, { [`${prefixCls}-show-span`]: props.span && slots.default }, { [`${prefixCls}-normal`]: props.normal }]);
</script>
<style lang="less" scoped>
  @prefix-cls: ~'@{namespace}-basic-title';

  .@{prefix-cls} {
    position: relative;
    display: flex;
    font-size: 16px;
    font-weight: 500;
    line-height: 24px;
    color: @text-color-base;
    user-select: none;
    align-items: center;

    &-normal {
      font-size: 14px;
      font-weight: 500;
    }

    &-show-span {
      padding-left: 7px;
      &::before {
        position: absolute;
        top: 4px;
        left: 0;
        width: 3px;
        height: 16px;
        margin-right: 4px;
        background-color: @primary-color;
        content: '';
      }
    }

    :deep(&-help) {
      display: flex;
      align-items: center;
    }
  }
</style>
