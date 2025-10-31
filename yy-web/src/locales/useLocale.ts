/**
 * Multi-language related operations
 */
import type { LocaleType } from '#/config';

import { i18n } from './setupI18n';
import { useLocaleStoreWithOut } from '@/store/modules/locale';
import { unref, computed } from 'vue';
import { loadLocalePool, setHtmlPageLang } from './helper';
// import { getLangJson } from '@/api/system/baseLang'; // 已删除 - 后端无此接口
import { localeSetting } from '@/settings/localeSetting';

interface LangModule {
  message: Recordable;
  dateLocale: Recordable;
  dateLocaleName: string;
}

const { availableLocales } = localeSetting;

function setI18nLanguage(locale: LocaleType) {
  const localeStore = useLocaleStoreWithOut();

  if (i18n.mode === 'legacy') {
    i18n.global.locale = locale;
  } else {
    (i18n.global.locale as any).value = locale;
  }
  localeStore.setLocaleInfo({ locale });
  setHtmlPageLang(locale);
}

export function useLocale() {
  const localeStore = useLocaleStoreWithOut();
  const getLocale = computed<LocaleType>(() => localeStore.getLocale);
  const getShowLocalePicker = computed(() => localeStore.getShowPicker);

  const getAntdLocale = computed((): any => {
    return (i18n.global.getLocaleMessage(unref(getLocale)) as any)?.antdLocale ?? {};
  });

  // Switching the language will change the locale of useI18n
  // And submit to configuration modification
  async function changeLocale(locale: LocaleType) {
    const globalI18n = i18n.global;
    const currentLocale = unref(globalI18n.locale);
    if (currentLocale === locale) {
      return locale;
    }

    if (loadLocalePool.includes(locale)) {
      setI18nLanguage(locale);
      return locale;
    }
    if (!availableLocales.includes(locale)) locale = 'zh_CN';
    const langModule = ((await import(`./lang/${locale}.ts`)) as any).default as LangModule;
    if (!langModule) return;

    const { message } = langModule;

    globalI18n.setLocaleMessage(locale, message);
    loadLocalePool.push(locale);

    setI18nLanguage(locale);
    return locale;
  }
  async function initLocale(locale: LocaleType) {
    // 确保locale有效
    if (!availableLocales.includes(locale)) locale = 'zh_CN';

    try {
      // 先加载本地语言包
      const langModule = ((await import(`./lang/${locale}.ts`)) as any).default as LangModule;
      const { message: defaultMessage } = langModule;

      // 尝试获取服务端的额外翻译（可选功能）- 已禁用，后端无此接口
      // try {
      //   const res = await getLangJson();
      //   // 如果服务端返回了有效的翻译数据，则合并使用
      //   if (res && res.data && res.data !== null && res.data !== '{}') {
      //     const serverMessage = JSON.parse(res.data);
      //     // 合并服务端翻译和本地翻译（服务端优先）
      //     setLocale(locale, { ...defaultMessage, ...serverMessage });
      //     return;
      //   }
      // } catch (serverError) {
      //   // 服务端加载失败不影响使用，继续使用本地语言包
      // }

      // 如果服务端加载失败或返回空，直接使用本地语言包
      setLocale(locale, defaultMessage);
    } catch (error) {
      console.error('[多语言] 初始化失败:', error);
    }
  }
  function setLocale(locale: LocaleType, message) {
    const globalI18n = i18n.global;
    globalI18n.setLocaleMessage(locale, message);
    // 避免重复添加
    if (!loadLocalePool.includes(locale)) {
      loadLocalePool.push(locale);
    }
    setI18nLanguage(locale);
  }

  return {
    getLocale,
    getShowLocalePicker,
    changeLocale,
    initLocale,
    getAntdLocale,
  };
}
