/**
 * 路由配置文件
 * 
 * 功能说明：
 * 1. 创建Vue Router实例
 * 2. 配置路由模式（History模式）
 * 3. 管理路由白名单
 * 4. 提供路由重置功能
 * 5. 支持应用识别码路径
 */

import type { RouteRecordRaw } from 'vue-router';
import type { App } from 'vue';

import { createRouter, createWebHistory } from 'vue-router';
import { basicRoutes } from './routes';
import { getYouyiAppId } from '@/utils/youyi';

// 白名单应该包含基本静态路由（不会在路由重置时被删除）
const WHITE_NAME_LIST: string[] = [];
const getRouteNames = (array: any[]) =>
  array.forEach(item => {
    WHITE_NAME_LIST.push(item.name);
    getRouteNames(item.children || []);
  });
getRouteNames(basicRoutes);

// 取路径上的应用识别码的作为基础路由
let VITE_PUBLIC_PATH = import.meta.env.VITE_PUBLIC_PATH;
const appId = getYouyiAppId();
if (appId) VITE_PUBLIC_PATH = '/' + appId;

/**
 * 创建路由实例
 * 使用History模式，支持动态基础路径
 */
export const router = createRouter({
  // 创建HTML5历史记录模式
  history: createWebHistory(VITE_PUBLIC_PATH),
  // 初始路由列表
  routes: basicRoutes as unknown as RouteRecordRaw[],
  // 是否禁止尾部斜杠
  strict: true,
  // 路由切换后的滚动行为
  scrollBehavior: () => ({ left: 0, top: 0 }),
});

/**
 * 重置路由
 * 清除所有非白名单路由，用于用户登出时清理动态路由
 */
export function resetRouter() {
  router.getRoutes().forEach(route => {
    const { name } = route;
    if (name && !WHITE_NAME_LIST.includes(name as string)) {
      router.hasRoute(name) && router.removeRoute(name);
    }
  });
}

/**
 * 配置路由器并安装到应用
 * @param app Vue应用实例
 */
export function setupRouter(app: App<Element>) {
  app.use(router);
}
