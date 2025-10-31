import { useI18n } from '@/hooks/web/useI18n';

const { t } = useI18n();

export const relationFormProps = {
  value: [String, Number, Array] as PropType<String | number | string[] | number[] | [string, number][]>,
  modelId: { type: String, default: '' },
  relationField: { type: String, default: '' },
  field: { type: String, default: '' },
  placeholder: { type: String, default: t('common.chooseText') },
  columnOptions: { type: Array, default: () => [] },
  hasPage: { type: Boolean, default: false },
  pageSize: { type: Number, default: 20 },
  allowClear: { type: Boolean, default: true },
  size: { type: String, default: 'default' },
  disabled: { type: Boolean, default: false },
  multiple: { type: Boolean, default: false },
  popupType: { type: String, default: 'dialog' },
  popupTitle: { type: String, default: t('component.youyi.popupSelect.modalTitle') },
  popupWidth: { type: String, default: '800px' },
};
