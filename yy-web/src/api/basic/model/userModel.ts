import type { UserInfo, SysConfigInfo, PermissionInfo } from '#/store';
import type { RouteMeta } from 'vue-router';

export interface LoginParams {
  account: string;
  password: string;
  code?: string;
  origin?: string;
  timestamp?: number | string;
  youyi_ticket?: string;
}

/**
 * @description: Login interface parameters
 */
export interface LoginRequestParams extends LoginParams {
  grant_type: string;
}

export interface BackMenu {
  id: number;
  enCode: string;
  fullName: string;
  icon: string;
  linkTarget: string;
  parentId: number;
  hasChildren: boolean;
  propertyJson: string;
  sortCode: number;
  type: number;
  urlAddress: string | null;
  component?: string | null;
  menuType?: string;
  path?: string;
  children?: Nullable<BackMenu[]>;
}

export interface RouteItem {
  path: string;
  component: any;
  meta: RouteMeta;
  name?: string;
  alias?: string | string[];
  redirect?: string;
  caseSensitive?: boolean;
  children?: RouteItem[];
}

/**
 * @description: Get user information return value
 */
export interface GetUserInfoModel {
  menuList: BackMenu[];
  permissionList: PermissionInfo[];
  routerList: BackMenu[];
  sysConfigInfo: SysConfigInfo;
  userInfo: UserInfo;
}
