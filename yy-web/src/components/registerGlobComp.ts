import type { App } from 'vue';
import { Button } from './Button';
import {
  Input,
  InputNumber,
  Layout,
  Form,
  Switch,
  Dropdown,
  Menu,
  Select,
  Table,
  Checkbox,
  Tabs,
  Collapse,
  Card,
  Tooltip,
  Row,
  Col,
  Popconfirm,
  Divider,
  Alert,
  AutoComplete,
  Cascader,
  Rate,
  Slider,
  Avatar,
  Tag,
  Space,
  Steps,
  Popover,
  Radio,
  Progress,
  Image,
  Upload,
} from 'ant-design-vue';

import { BasicHelp, BasicCaption } from '@/components/Basic';
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
import { YouyiEmpty } from '@/components/Youyi/Empty';
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
import { YouyiUploadFile, YouyiUploadImg, YouyiUploadImgSingle, YouyiUploadBtn } from '@/components/Youyi/Upload';
import { Tinymce } from '@/components/Tinymce/index';
import { YouyiNumberRange } from '@/components/Youyi/NumberRange';
import { YouyiRelationFormAttr } from '@/components/Youyi/RelationFormAttr';
import { YouyiPopupSelect, YouyiPopupTableSelect } from '@/components/Youyi/PopupSelect';
import { YouyiPopupAttr } from '@/components/Youyi/PopupAttr';
import { YouyiCalculate } from '@/components/Youyi/Calculate';
import { YouyiLocation } from '@/components/Youyi/Location';
import { YouyiIframe } from '@/components/Youyi/Iframe';
import { YouyiTextTag } from '@/components/Youyi/TextTag';

const YouyiEditor = Tinymce;
YouyiEditor.name = 'YouyiEditor';
const YouyiGroupTitle = BasicCaption;
YouyiGroupTitle.name = 'YouyiGroupTitle';

export function registerGlobComp(app: App) {
  app
    .use(Input)
    .use(InputNumber)
    .use(Button)
    .use(Layout)
    .use(Form)
    .use(Switch)
    .use(Dropdown)
    .use(Menu)
    .use(Select)
    .use(Table)
    .use(Checkbox)
    .use(Tabs)
    .use(Card)
    .use(Collapse)
    .use(Tooltip)
    .use(Row)
    .use(Col)
    .use(Popconfirm)
    .use(Popover)
    .use(Divider)
    .use(Slider)
    .use(Rate)
    .use(Alert)
    .use(AutoComplete)
    .use(Cascader)
    .use(Avatar)
    .use(Tag)
    .use(Space)
    .use(Steps)
    .use(Radio)
    .use(Progress)
    .use(Image)
    .use(Upload)
    .use(BasicHelp)
    .use(YouyiAlert)
    .use(YouyiRate)
    .use(YouyiSlider)
    .use(YouyiAreaSelect)
    .use(YouyiAutoComplete)
    .use(YouyiButton)
    .use(YouyiCron)
    .use(YouyiCascader)
    .use(YouyiCheckbox)
    .use(YouyiCheckboxSingle)
    .use(YouyiColorPicker)
    .use(YouyiDatePicker)
    .use(YouyiDateRange)
    .use(YouyiTimePicker)
    .use(YouyiTimeRange)
    .use(YouyiDivider)
    .use(YouyiEmpty)
    .use(YouyiGroupTitle)
    .use(YouyiIconPicker)
    .use(YouyiInput)
    .use(YouyiTextarea)
    .use(YouyiI18nInput)
    .use(YouyiInputNumber)
    .use(YouyiLink)
    .use(YouyiOrganizeSelect)
    .use(YouyiDepSelect)
    .use(YouyiPosSelect)
    .use(YouyiGroupSelect)
    .use(YouyiRoleSelect)
    .use(YouyiUserSelect)
    .use(YouyiUsersSelect)
    .use(YouyiOpenData)
    .use(YouyiQrcode)
    .use(YouyiBarcode)
    .use(YouyiRadio)
    .use(YouyiSelect)
    .use(YouyiSign)
    .use(YouyiSignature)
    .use(YouyiSwitch)
    .use(YouyiText)
    .use(YouyiTreeSelect)
    .use(YouyiEditor)
    .use(YouyiRelationFormAttr)
    .use(YouyiPopupSelect)
    .use(YouyiPopupTableSelect)
    .use(YouyiPopupAttr)
    .use(YouyiNumberRange)
    .use(YouyiCalculate)
    .use(YouyiUploadFile)
    .use(YouyiUploadImg)
    .use(YouyiUploadImgSingle)
    .use(YouyiUploadBtn)
    .use(YouyiLocation)
    .use(YouyiIframe)
    .use(YouyiTextTag);
}
