/**
 * 应用入口文件
 * 
 * 功能说明：
 * 1. 引入全局样式：Ant Design样式、Windi CSS、自定义样式
 * 2. 初始化应用配置：状态管理、路由、国际化、全局组件等
 * 3. 配置全局功能：错误处理、指令、路由守卫
 * 4. 挂载应用到DOM
 */

import 'ant-design-vue/dist/reset.css';
import '@/design/index.less';
import '@/design/windi-base.css';
import 'virtual:windi-components.css';
import 'virtual:windi-utilities.css';
// 注册SVG图标精灵
import 'virtual:svg-icons-register';
import App from './App.vue';
import { createApp } from 'vue';
import { initAppConfigStore } from '@/logics/initAppConfig';
import { setupErrorHandle } from '@/logics/error-handle';
import { router, setupRouter } from '@/router';
import { setupRouterGuard } from '@/router/guard';
import { setupStore } from '@/store';
import { setupGlobDirectives } from '@/directives';
import { setupI18n } from '@/locales/setupI18n';
import { registerGlobComp } from '@/components/registerGlobComp';
import gridLayout from 'vue-grid-layout';
import mitt from '@/utils/mitt';
// 修复打印插件会一直自动连接websocket的问题
import { disAutoConnect } from 'vue-plugin-hiprint';
disAutoConnect();

const emitter = mitt();

/**
 * 启动应用初始化函数
 * 按顺序初始化各项功能模块
 */
async function bootstrap() {
  const app = createApp(App);

  // 注入事件发射器provider
  app.provide('emitter', emitter);

  // 配置Pinia状态管理
  setupStore(app);

  // 初始化内部系统配置（主题、缓存等）
  initAppConfigStore();

  // 注册全局组件（如BasicButton、BasicModal等）
  registerGlobComp(app);

  // 多语言配置
  await setupI18n(app);

  // 配置路由
  setupRouter(app);

  // 路由守卫配置（权限验证、进度条等）
  setupRouterGuard(router);

  // 注册全局指令（v-permission、v-debounce等）
  setupGlobDirectives(app);

  // 配置全局错误处理
  setupErrorHandle(app);

  // 使用网格布局插件
  app.use(gridLayout);

  // 挂载应用到DOM
  app.mount('#app');
}

// 启动应用
bootstrap();
