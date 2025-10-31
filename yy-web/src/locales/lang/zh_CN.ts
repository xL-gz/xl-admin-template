import antdLocale from 'ant-design-vue/es/locale/zh_CN';
import zhCNCustomLocale from './zh_CN.json';

// 确保 JSON 翻译数据正确导入
// 关键：先保存 JSON 的 common（在合并前），避免被 antdLocale 覆盖
const jsonCommon = zhCNCustomLocale?.common || {};

const finalMessage: any = {
  ...zhCNCustomLocale,  // 先展开自定义翻译（包含 common、component 等）
};

// 如果有 antdLocale，需要特别注意合并逻辑
if (antdLocale && typeof antdLocale === 'object') {
  const antdCommon = (antdLocale as any).common;
  
  // 如果 antdLocale 有 common 属性，需要合并（但确保 JSON 的 common 优先）
  if (antdCommon) {
    finalMessage.common = {
      ...antdCommon,  // 先放 antdLocale 的 common（confirm, cancel）
      ...jsonCommon,  // 然后用 JSON 的 common 覆盖/补充（包含 addText 等所有翻译）
    };
  }
  
  // 添加 antdLocale 作为独立属性（用于 Ant Design 组件）
  finalMessage.antdLocale = antdLocale;
}

export default {
  message: finalMessage,
};
