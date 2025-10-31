import { defHttp } from '@/utils/http/axios';
import { LoginParams } from './model/userModel';

enum Api {
  Login = '/auth/login',
  Logout = '/auth/logout',
  GetUserInfo = '/auth/userInfo',
}

// 用户登录
export function loginApi(params: LoginParams) {
  return defHttp.post({ 
    url: Api.Login, 
    data: {
      username: params.account,
      password: params.password,
    },
  });
}

// 获取当前用户信息（包含菜单和权限）
export function getUserInfo() {
  return defHttp.get({ url: Api.GetUserInfo });
}

// 退出登录
export function doLogout() {
  return defHttp.post({ url: Api.Logout });
}

// 锁屏解锁登录
export function unlock(data: LoginParams) {
  return defHttp.post({ url: '/auth/unlock', data });
}

// 更新密码消息
export function updatePasswordMessage() {
  return defHttp.post({ url: '/auth/updatePasswordMessage' });
}
