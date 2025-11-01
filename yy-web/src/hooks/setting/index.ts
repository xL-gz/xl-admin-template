import type { GlobConfig } from '#/config';

import { warn } from '@/utils/log';
import { getAppEnvConfig, isDevMode } from '@/utils/env';

/**
 * 获取配置的API地址
 * 优先从localStorage读取（系统配置中的API地址），如果没有则使用环境变量
 */
function getConfiguredApiUrl(): string {
  const apiServerType = localStorage.getItem('apiServerType');
  const apiBaseUrl = localStorage.getItem('apiBaseUrl');
  
  // 如果配置了自定义API地址，使用自定义地址
  if (apiBaseUrl && apiBaseUrl.trim()) {
    return apiBaseUrl.trim();
  }
  
  // 如果是本地服务器类型，使用默认本地地址
  if (apiServerType === 'local') {
    return 'http://localhost:20250';
  }
  
  // 其他情况使用环境变量配置的地址
  const { VITE_GLOB_API_URL } = getAppEnvConfig();
  return VITE_GLOB_API_URL || 'http://localhost:20250';
}

export const useGlobSetting = (): Readonly<GlobConfig> => {
  const { VITE_GLOB_APP_TITLE, VITE_GLOB_API_URL, VITE_GLOB_APP_SHORT_NAME, VITE_GLOB_API_URL_PREFIX, VITE_GLOB_WEBSOCKET_URL } = getAppEnvConfig();

  if (!/[a-zA-Z\_]*/.test(VITE_GLOB_APP_SHORT_NAME)) {
    warn(`VITE_GLOB_APP_SHORT_NAME Variables can only be characters/underscores, please modify in the environment variables and re-running.`);
  }

  // 获取实际使用的API地址（优先从配置读取）
  const actualApiUrl = getConfiguredApiUrl();
  const prodUrlPrefix = actualApiUrl && /https?:\/\//.test(actualApiUrl) ? actualApiUrl : window.location.origin + actualApiUrl;

  // Take global configuration
  const glob: Readonly<GlobConfig> = {
    title: VITE_GLOB_APP_TITLE,
    apiUrl: actualApiUrl, // 使用配置的API地址
    shortName: VITE_GLOB_APP_SHORT_NAME,
    urlPrefix: VITE_GLOB_API_URL_PREFIX,
    uploadUrl: actualApiUrl + '/api/file/Uploader',
    webSocketUrl: VITE_GLOB_WEBSOCKET_URL,
    cipherKey: 'EY8WePvjM5GGwQzn', // 加密key
    aMapJsKey: 'a4350693d55b26954dfb921ce4e0db4f',
    aMapWebKey: 'dc64826438197b23e36f15388536862a',
    aMapSecurityJsCode: '817c8a96c03eb8cfcbf7c70e72ac82a6',
    // 本地文件预览
    filePreviewServer: isDevMode() ? 'http://localhost:30090/FileServer' : actualApiUrl + '/FileServer',
    // 大屏应用前端路径
    dataVUrl: isDevMode() ? 'http://localhost:8100/DataV/' : prodUrlPrefix + '/DataV/',
    // 数据报表接口
    reportServer: isDevMode() ? 'http://localhost:30007' : actualApiUrl + '/ReportServer',
    // 报表前端路径
    report: isDevMode() ? 'http://localhost:8200' : actualApiUrl + '/Report',
  };
  return glob as Readonly<GlobConfig>;
};
