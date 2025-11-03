/**
 * Pinia状态管理初始化
 * 
 * 什么是Pinia？
 * Pinia 是 Vue 3 官方推荐的状态管理库，用于管理应用的全局状态数据。
 * 
 * 功能说明：
 * 1. 创建Pinia实例 - 提供状态管理的核心能力
 * 2. 安装到Vue应用 - 在应用启动时注册Pinia
 * 3. 为应用提供全局状态管理能力 - 可以在任何组件中共享数据
 * 
 * 本项目中的Store模块：
 * - app.ts - 应用全局配置（主题、菜单设置等）
 * - user.ts - 用户信息和登录状态
 * - permission.ts - 权限和路由管理
 * - locale.ts - 多语言设置
 * - multipleTab.ts - 多标签页管理
 * - base.ts - 基础数据缓存
 * - organize.ts - 组织架构数据
 * 
 * 如何使用？
 * 1. 在组件中引入：import { useUserStore } from '@/store/modules/user'
 * 2. 获取实例：const userStore = useUserStore()
 * 3. 读取状态：userStore.getUserInfo
 * 4. 修改状态：userStore.setUserInfo(newInfo)
 * 
 * 详细教程请查看：yy-web/Pinia状态管理说明.md
 */

import type { App } from 'vue';
import { createPinia } from 'pinia';

// 创建Pinia实例（整个应用共享这一个实例）
const store = createPinia();

/**
 * 配置状态管理并安装到Vue应用
 * 在main.ts的bootstrap函数中被调用，确保在路由初始化之前配置
 * 
 * @param app Vue应用实例
 */
export function setupStore(app: App<Element>) {
  app.use(store);
}

// 导出store实例，供其他模块使用（如路由守卫、工具函数等）
export { store };
