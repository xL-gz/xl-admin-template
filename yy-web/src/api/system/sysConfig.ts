import { defHttp } from '@/utils/http/axios';

enum Api {
  Prefix = '/api/system/SysConfig',
}

// 获取系统配置
export function getSysConfig() {
  return defHttp.get({ url: Api.Prefix });
}

// 更新系统配置
export function update(data) {
  return defHttp.put({ url: Api.Prefix, data });
}