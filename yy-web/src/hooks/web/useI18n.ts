import { i18n } from '@/locales/setupI18n';

type I18nGlobalTranslation = {
  (key: string): string;
  (key: string, locale: string): string;
  (key: string, locale: string, list: unknown[]): string;
  (key: string, locale: string, named: Record<string, unknown>): string;
  (key: string, list: unknown[]): string;
  (key: string, named: Record<string, unknown>): string;
};

type I18nTranslationRestParameters = [string, any];

function getKey(namespace: string | undefined, key: string) {
  if (!namespace) {
    return key;
  }
  if (key.startsWith(namespace)) {
    return key;
  }
  return `${namespace}.${key}`;
}

export function useI18n(namespace?: string): {
  t: I18nGlobalTranslation;
} {
  const normalFn = {
    t: (key: string) => {
      // 如果 i18n 未初始化，返回 key 但输出警告（仅在开发环境）
      if (process.env.NODE_ENV === 'development') {
        console.warn('[i18n] i18n 实例未初始化，无法翻译:', getKey(namespace, key));
      }
      return getKey(namespace, key);
    },
  };

  if (!i18n) {
    return normalFn;
  }

  const { t, ...methods } = i18n.global;

  const tFn: I18nGlobalTranslation = (key: string, ...arg: any[]) => {
    if (!key) return '';
    const fullKey = getKey(namespace, key);
    const translated = t(fullKey, ...(arg as I18nTranslationRestParameters));
    
    // 如果翻译结果等于原始 key，说明翻译未找到，输出警告（仅在开发环境）
    if (process.env.NODE_ENV === 'development' && translated === fullKey) {
      const currentLocale = i18n.global.locale.value || i18n.global.locale;
      const messages = i18n.global.getLocaleMessage(currentLocale);
      console.warn('[i18n] 翻译未找到:', {
        key: fullKey,
        locale: currentLocale,
        hasMessages: !!messages,
        messageKeys: messages ? Object.keys(messages).slice(0, 5) : [],
      });
    }
    
    return translated;
  };
  return {
    ...methods,
    t: tFn,
  };
}

// Why write this function？
// Mainly to configure the vscode i18nn ally plugin. This function is only used for routing and menus. Please use useI18n for other places

// 为什么要编写此函数？
// 主要用于配合vscode i18nn ally插件。此功能仅用于路由和菜单。请在其他地方使用useI18n
export const t = (key: string) => key;
