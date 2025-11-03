<!--
  页面标题栏组件
  
  功能说明：
  1. 显示页面标题和操作按钮的布局组件
  2. 支持标题居中、左对齐、右对齐
  3. 支持底部边框显示
  4. 通常用于列表页面的标题栏
  
  使用示例：
  <BasicCaption content="标题" />
  <BasicCaption :content="'用户管理'" :contentPosition="'center'">
    <template #action>
      <BasicButton>操作</BasicButton>
    </template>
  </BasicCaption>
-->
<template>
  <div :class="getClass">
    <div :class="`${prefixCls}-content`" :style="{ 'justify-content': getContentPosition }">
      <slot name="content" v-if="slots.content"></slot>
      <BasicTitle :helpMessage="helpMessage" v-if="!slots.content && content">
        {{ content }}
      </BasicTitle>
    </div>
    <div :class="`${prefixCls}__action`" v-if="slots.action">
      <slot name="action" v-if="slots.action"></slot>
    </div>
  </div>
</template>
<script lang="ts" setup>
  import { computed, useSlots } from 'vue';
  import BasicTitle from './BasicTitle.vue';
  import { useDesign } from '@/hooks/web/useDesign';
  import type { PropType } from 'vue';

  const props = defineProps({
    helpMessage: {
      type: [String, Array] as PropType<string | string[]>,
      default: '',
    },
    content: {
      type: String,
      default: '',
    },
    contentPosition: {
      type: String as PropType<'left' | 'center' | 'right'>,
      default: 'left',
    },
    bordered: {
      type: Boolean,
      default: true,
    },
  });
  const slots = useSlots();
  const { prefixCls } = useDesign('basic-caption');
  const getClass = computed(() => [prefixCls, { [`${prefixCls}-border`]: props.bordered }]);
  const getContentPosition = computed(() => {
    if (props.contentPosition === 'left') return 'flex-start';
    if (props.contentPosition === 'right') return 'flex-end';
    return props.contentPosition;
  });
</script>

<style lang="less" scoped>
  @prefix-cls: ~'@{namespace}-basic-caption';

  .@{prefix-cls} {
    min-height: 50px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    box-sizing: border-box;
    word-break: break-all;
    padding-top: 10px;
    padding-bottom: 10px;
    &-border {
      border-bottom: 1px solid @border-color-base;
    }
    &-content {
      flex: 1;
      display: flex;
    }
    &__action {
      margin-left: 8px;
      flex-shrink: 0;
    }
  }
</style>
