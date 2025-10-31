import type { Component } from 'vue';
import type { ComponentType } from './types/index';

/**
 * Component list, register here to setting it in the form
 */
import { StrengthMeter } from '@/components/StrengthMeter';
import { CountdownInput } from '@/components/CountDown';
// youyi 组件
import {
  YouyiAlert,
  YouyiAreaSelect,
  YouyiAutoComplete,
  YouyiButton,
  YouyiCron,
  YouyiCascader,
  YouyiColorPicker,
  YouyiCheckbox,
  YouyiCheckboxSingle,
  YouyiDatePicker,
  YouyiDateRange,
  YouyiTimePicker,
  YouyiTimeRange,
  YouyiMonthPicker,
  YouyiWeekPicker,
  YouyiDivider,
  YouyiEditor,
  YouyiGroupTitle,
  YouyiIconPicker,
  YouyiInput,
  YouyiInputPassword,
  YouyiInputGroup,
  YouyiInputSearch,
  YouyiTextarea,
  YouyiInputNumber,
  YouyiLink,
  YouyiOpenData,
  YouyiOrganizeSelect,
  YouyiDepSelect,
  YouyiPosSelect,
  YouyiGroupSelect,
  YouyiRoleSelect,
  YouyiUserSelect,
  YouyiUsersSelect,
  YouyiQrcode,
  YouyiBarcode,
  YouyiRadio,
  YouyiRate,
  YouyiSelect,
  YouyiSlider,
  YouyiSign,
  YouyiSignature,
  YouyiSwitch,
  YouyiText,
  YouyiTreeSelect,
  YouyiUploadFile,
  YouyiUploadImg,
  YouyiUploadImgSingle,
  YouyiRelationForm,
  YouyiRelationFormAttr,
  YouyiPopupSelect,
  YouyiPopupTableSelect,
  YouyiPopupAttr,
  YouyiNumberRange,
  YouyiCalculate,
  YouyiInputTable,
  YouyiLocation,
  YouyiIframe,
} from '@/components/Youyi';

const componentMap = new Map<ComponentType, Component>();

componentMap.set('StrengthMeter', StrengthMeter);
componentMap.set('InputCountDown', CountdownInput);

componentMap.set('InputGroup', YouyiInputGroup);
componentMap.set('InputSearch', YouyiInputSearch);
componentMap.set('MonthPicker', YouyiMonthPicker);
componentMap.set('WeekPicker', YouyiWeekPicker);

componentMap.set('Alert', YouyiAlert);
componentMap.set('AreaSelect', YouyiAreaSelect);
componentMap.set('AutoComplete', YouyiAutoComplete);
componentMap.set('Button', YouyiButton);
componentMap.set('Cron', YouyiCron);
componentMap.set('Cascader', YouyiCascader);
componentMap.set('ColorPicker', YouyiColorPicker);
componentMap.set('Checkbox', YouyiCheckbox);
componentMap.set('YouyiCheckboxSingle', YouyiCheckboxSingle);
componentMap.set('DatePicker', YouyiDatePicker);
componentMap.set('DateRange', YouyiDateRange);
componentMap.set('TimePicker', YouyiTimePicker);
componentMap.set('TimeRange', YouyiTimeRange);
componentMap.set('Divider', YouyiDivider);
componentMap.set('Editor', YouyiEditor);
componentMap.set('GroupTitle', YouyiGroupTitle);
componentMap.set('Input', YouyiInput);
componentMap.set('InputPassword', YouyiInputPassword);
componentMap.set('Textarea', YouyiTextarea);
componentMap.set('InputNumber', YouyiInputNumber);
componentMap.set('IconPicker', YouyiIconPicker);
componentMap.set('Link', YouyiLink);
componentMap.set('OrganizeSelect', YouyiOrganizeSelect);
componentMap.set('DepSelect', YouyiDepSelect);
componentMap.set('PosSelect', YouyiPosSelect);
componentMap.set('GroupSelect', YouyiGroupSelect);
componentMap.set('RoleSelect', YouyiRoleSelect);
componentMap.set('UserSelect', YouyiUserSelect);
componentMap.set('UsersSelect', YouyiUsersSelect);
componentMap.set('Qrcode', YouyiQrcode);
componentMap.set('Barcode', YouyiBarcode);
componentMap.set('Radio', YouyiRadio);
componentMap.set('Rate', YouyiRate);
componentMap.set('Select', YouyiSelect);
componentMap.set('Slider', YouyiSlider);
componentMap.set('Sign', YouyiSign);
componentMap.set('Signature', YouyiSignature);
componentMap.set('Switch', YouyiSwitch);
componentMap.set('Text', YouyiText);
componentMap.set('TreeSelect', YouyiTreeSelect);
componentMap.set('UploadFile', YouyiUploadFile);
componentMap.set('UploadImg', YouyiUploadImg);
componentMap.set('UploadImgSingle', YouyiUploadImgSingle);
componentMap.set('BillRule', YouyiInput);
componentMap.set('ModifyUser', YouyiInput);
componentMap.set('ModifyTime', YouyiInput);
componentMap.set('CreateUser', YouyiOpenData);
componentMap.set('CreateTime', YouyiOpenData);
componentMap.set('CurrOrganize', YouyiOpenData);
componentMap.set('CurrPosition', YouyiOpenData);
componentMap.set('RelationForm', YouyiRelationForm);
componentMap.set('RelationFormAttr', YouyiRelationFormAttr);
componentMap.set('PopupSelect', YouyiPopupSelect);
componentMap.set('PopupTableSelect', YouyiPopupTableSelect);
componentMap.set('PopupAttr', YouyiPopupAttr);
componentMap.set('NumberRange', YouyiNumberRange);
componentMap.set('Calculate', YouyiCalculate);
componentMap.set('InputTable', YouyiInputTable);
componentMap.set('Location', YouyiLocation);
componentMap.set('Iframe', YouyiIframe);

export function add(compName: ComponentType, component: Component) {
  componentMap.set(compName, component);
}

export function del(compName: ComponentType) {
  componentMap.delete(compName);
}

export { componentMap };
