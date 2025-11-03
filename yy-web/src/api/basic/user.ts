/**
 * 用户认证相关API
 * 
 * 功能说明：
 * 1. 用户登录接口
 * 2. 获取用户信息（包含菜单和权限）
 * 3. 退出登录
 * 4. 锁屏解锁
 * 5. 密码更新
 * 
 * 使用示例：
 * import { loginApi, getUserInfo } from '@/api/basic/user';
 * const res = await loginApi({ account: 'admin', password: '123456' });
 */
import { defHttp } from '@/utils/http/axios';
import { LoginParams } from './model/userModel';

enum Api {
  Login = '/auth/login',
  Logout = '/auth/logout',
  GetUserInfo = '/auth/userInfo',
}

/**
 * 用户登录
 * @param params 登录参数（账号、密码）
 * @returns 返回Token和用户信息
 */
export function loginApi(params: LoginParams) {
  return defHttp.post({ 
    url: Api.Login, 
    data: {
      username: params.account,
      password: params.password,
    },
  });
}

/**
 * 获取当前用户信息（包含菜单和权限）
 * @returns 返回用户信息、菜单列表、权限列表、系统配置
 */
export function getUserInfo() {
  return defHttp.get({ url: Api.GetUserInfo });
}

/**
 * 退出登录
 * @returns 退出登录结果
 */
export function doLogout() {
  return defHttp.post({ url: Api.Logout });
}

/**
 * 锁屏解锁登录
 * @param data 解锁密码
 * @returns 解锁结果
 */
export function unlock(data: LoginParams) {
  return defHttp.post({ url: '/auth/unlock', data });
}

/**
 * 更新密码消息
 * @returns 更新结果
 */
export function updatePasswordMessage() {
  return defHttp.post({ url: '/auth/updatePasswordMessage' });
}
