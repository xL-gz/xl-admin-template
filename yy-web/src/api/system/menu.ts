/**
 * 菜单管理相关API
 *
 * 功能说明：
 * 1. 菜单的增删改查操作
 * 2. 获取菜单树形结构
 * 3. 菜单选择器数据获取
 * 4. 菜单导出和用户菜单获取
 */
import { defHttp } from '@/utils/http/axios';

enum Api {
  Prefix = '/api/system/Menu',
}

/**
 * 获取指定应用系统的菜单列表（树形结构）
 */
export function getMenuList(data) {
  return defHttp.get({
    url: `${Api.Prefix}/ModuleBySystem/${data.systemId}`,
    params: data,
  });
}

/**
 * 获取所有菜单列表（树形结构）
 */
export function getAllMenuList(data?) {
  return defHttp.get({ url: Api.Prefix + '/list', params: data });
}

/**
 * 获取上级菜单下拉框（带systemId过滤）
 */
export function getMenuSelector(data, id, systemId = '0') {
  return defHttp.get({
    url: `${Api.Prefix}/Selector/${id || '0'}/${systemId}`,
    params: data,
  });
}

/**
 * 获取所有菜单选择器
 */
export function getSelectorAll(data) {
  return defHttp.get({
    url: `${Api.Prefix}/Selector/All`,
    params: data,
  });
}

/**
 * 新建菜单
 */
export function create(data) {
  return defHttp.post({ url: Api.Prefix, data });
}

/**
 * 修改菜单
 */
export function update(data) {
  return defHttp.put({ url: `${Api.Prefix}/${data.id}`, data });
}

/**
 * 获取菜单详情
 */
export function getInfo(id) {
  return defHttp.get({ url: `${Api.Prefix}/${id}` });
}

/**
 * 删除菜单
 */
export function delMenu(id) {
  return defHttp.delete(
    { url: `${Api.Prefix}/${id}` },
    {
      errorMessageMode: 'message', // 确保显示错误提示
    },
  );
}

/**
 * 导出系统菜单数据
 */
export function exportMenu(id) {
  return defHttp.get({ url: `${Api.Prefix}/${id}/Actions/Export` });
}

/**
 * 获取用户菜单树
 */
export function getUserMenus(userId: number) {
  return defHttp.get({ url: Api.Prefix + `/user/${userId}` });
}
