import { Input, DatePicker } from 'ant-design-vue';

// 自定义业务组件库（基于 Ant Design Vue 封装）
import { BasicCaption } from '@/components/Basic';
import { YouyiAlert } from '@/components/Youyi/Alert';
import { YouyiAreaSelect } from '@/components/Youyi/AreaSelect';
import { YouyiAutoComplete } from '@/components/Youyi/AutoComplete';
import { YouyiButton } from '@/components/Youyi/Button';
import { YouyiCron } from '@/components/Youyi/Cron';
import { YouyiCascader } from '@/components/Youyi/Cascader';
import { YouyiCheckbox, YouyiCheckboxSingle } from '@/components/Youyi/Checkbox';
import { YouyiColorPicker } from '@/components/Youyi/ColorPicker';
import { YouyiDatePicker, YouyiDateRange, YouyiTimePicker, YouyiTimeRange } from '@/components/Youyi/DatePicker';
import { YouyiDivider } from '@/components/Youyi/Divider';
import { YouyiIconPicker } from '@/components/Youyi/IconPicker';
import { YouyiInput, YouyiTextarea, YouyiI18nInput } from '@/components/Youyi/Input';
import { YouyiInputNumber } from '@/components/Youyi/InputNumber';
import { YouyiLink } from '@/components/Youyi/Link';
import { YouyiOpenData } from '@/components/Youyi/OpenData';
import { YouyiOrganizeSelect, YouyiDepSelect, YouyiPosSelect, YouyiGroupSelect, YouyiRoleSelect, YouyiUserSelect, YouyiUsersSelect } from '@/components/Youyi/Organize';
import { YouyiQrcode } from '@/components/Youyi/Qrcode';
import { YouyiBarcode } from '@/components/Youyi/Barcode';
import { YouyiRadio } from '@/components/Youyi/Radio';
import { YouyiSelect } from '@/components/Youyi/Select';
import { YouyiRate } from '@/components/Youyi/Rate';
import { YouyiSlider } from '@/components/Youyi/Slider';
import { YouyiSign } from '@/components/Youyi/Sign';
import { YouyiSignature } from '@/components/Youyi/Signature';
import { YouyiSwitch } from '@/components/Youyi/Switch';
import { YouyiText } from '@/components/Youyi/Text';
import { YouyiTreeSelect } from '@/components/Youyi/TreeSelect';
import { YouyiUploadFile, YouyiUploadImg, YouyiUploadImgSingle } from '@/components/Youyi/Upload';
import { Tinymce } from '@/components/Tinymce/index';
import { YouyiRelationForm } from '@/components/Youyi/RelationForm';
import { YouyiRelationFormAttr } from '@/components/Youyi/RelationFormAttr';
import { YouyiPopupSelect, YouyiPopupTableSelect } from '@/components/Youyi/PopupSelect';
import { YouyiPopupAttr } from '@/components/Youyi/PopupAttr';
import { YouyiNumberRange } from '@/components/Youyi/NumberRange';
import { YouyiCalculate } from '@/components/Youyi/Calculate';
import { YouyiInputTable } from '@/components/Youyi/InputTable';
import { YouyiLocation } from '@/components/Youyi/Location';
import { YouyiIframe } from '@/components/Youyi/Iframe';
import { YouyiTextTag } from '@/components/Youyi/TextTag';

const YouyiInputPassword = Input.Password;
YouyiInputPassword.name = 'YouyiInputPassword';
const YouyiInputGroup = Input.Group;
YouyiInputGroup.name = 'YouyiInputGroup';
const YouyiInputSearch = Input.Search;
YouyiInputSearch.name = 'YouyiInputSearch';
const YouyiEditor = Tinymce;
YouyiEditor.name = 'YouyiEditor';
const YouyiGroupTitle = BasicCaption;
YouyiGroupTitle.name = 'YouyiGroupTitle';
const YouyiMonthPicker = DatePicker.MonthPicker;
YouyiMonthPicker.name = 'YouyiMonthPicker';
const YouyiWeekPicker = DatePicker.WeekPicker;
YouyiWeekPicker.name = 'YouyiWeekPicker';

export {
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
  YouyiI18nInput,
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
  YouyiTextTag,
};
