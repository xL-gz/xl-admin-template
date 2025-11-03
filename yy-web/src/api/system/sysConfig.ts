/**
 * 系统配置相关API
 * 
 * 功能说明：
 * 1. 获取系统配置（基本设置、安全设置、存储配置等）
 * 2. 更新系统配置信息
 */
import { defHttp } from '@/utils/http/axios';

enum Api {
  Prefix = '/api/system/SysConfig',
}

/**
 * 获取系统配置
 * @returns 返回系统配置信息
 */
export function getSysConfig() {
  return defHttp.get({ url: Api.Prefix });
}

/**
 * 更新系统配置
 * @param data 系统配置数据
 * @returns 更新结果
 */
export function update(data) {
  return defHttp.put({ url: Api.Prefix, data });
}