<template>
  <div :style="getStyle">
    <a-input v-model:value="innerValue" v-bind="getBindValue" v-if="!detailed" />
    <p v-else>{{ innerValue }}</p>
  </div>
</template>

<script lang="ts" setup>
  import { Form } from 'ant-design-vue';
  import { ref, watch, onBeforeMount, inject, computed, unref } from 'vue';
  import { useGeneratorStore } from '@/store/modules/generator';
  import { useI18n } from '@/hooks/web/useI18n';
  import { useAttrs } from '@/hooks/core/useAttrs';

  defineOptions({ name: 'YouyiPopupAttr', inheritAttrs: false });
  const props = defineProps(['value', 'showField', 'relationField', 'detailed', 'isStorage', 'disabled']);
  const emit = defineEmits(['update:value']);
  const formItemContext = Form.useInjectFormItemContext();
  const generatorStore = useGeneratorStore();
  const { t } = useI18n();
  const emitter: any = inject('emitter');
  const innerValue = ref<string | number | undefined>(undefined);
  const attrs: any = useAttrs({ excludeDefaultKeys: false });

  const getBindValue = computed(() => ({
    readonly: true,
    disabled: props.disabled,
    placeholder: props.isStorage ? t('component.youyi.popupAttr.storage') : t('component.youyi.popupAttr.unStorage'),
  }));
  const getStyle = computed(() => (Reflect.has(unref(attrs), 'style') ? unref(attrs).style : {}));

  watch(
    () => generatorStore.getRelationData,
    val => {
      setValue(val);
    },
    {
      immediate: true,
      deep: true,
    },
  );

  function setValue(value) {
    if (props.isStorage || !props.showField || !props.relationField) return;
    const obj = value[props.relationField] || {};
    innerValue.value = obj[props.showField] || obj[props.showField] == 0 ? obj[props.showField] : '';
  }

  onBeforeMount(() => {
    emitter.on('setRelationData', data => {
      if (!props.isStorage || !props.showField || !props.relationField || props.relationField != data.youyiRelationField) return;
      innerValue.value = data[props.showField] || data[props.showField] == 0 ? data[props.showField] : '';
      emit('update:value', innerValue.value);
      formItemContext.onFieldChange();
    });
  });
</script>
