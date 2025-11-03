/**
 * 认证相关工具函数
 * 
 * 功能说明：
 * 1. Token获取和设置
 * 2. 认证数据缓存（支持localStorage和sessionStorage）
 * 3. 缓存清理功能
 * 
 * 使用示例：
 * import { getToken, setAuthCache } from '@/utils/auth';
 * const token = getToken();
 * setAuthCache(USER_INFO_KEY, userInfo);
 */

import { Persistent, BasicKeys } from '@/utils/cache/persistent';
import { CacheTypeEnum } from '@/enums/cacheEnum';
import projectSetting from '@/settings/projectSetting';
import { TOKEN_KEY } from '@/enums/cacheEnum';

const { permissionCacheType } = projectSetting;
const isLocal = permissionCacheType === CacheTypeEnum.LOCAL;

/**
 * 获取Token
 * @returns Token字符串
 */
export function getToken() {
  return getAuthCache(TOKEN_KEY);
}

/**
 * 获取认证相关的缓存数据
 * @param key 缓存键
 * @returns 缓存值
 */
export function getAuthCache<T>(key: BasicKeys) {
  const fn = isLocal ? Persistent.getLocal : Persistent.getSession;
  return fn(key) as T;
}

/**
 * 设置认证相关的缓存数据
 * @param key 缓存键
 * @param value 缓存值
 */
export function setAuthCache(key: BasicKeys, value) {
  const fn = isLocal ? Persistent.setLocal : Persistent.setSession;
  return fn(key, value, true);
}

/**
 * 清除所有认证相关的缓存
 * @param immediate 是否立即清除
 */
export function clearAuthCache(immediate = true) {
  const fn = isLocal ? Persistent.clearLocal : Persistent.clearSession;
  return fn(immediate);
}
