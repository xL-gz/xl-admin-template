// 样式导入
import 'ant-design-vue/dist/reset.css';
import '@/design/index.less';
import '@/design/windi-base.css';
import 'virtual:windi-components.css';
import 'virtual:windi-utilities.css';
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


const emitter = mitt();

// 3.应用配置和插件
async function bootstrap() {
  const app = createApp(App);            // 创建 Vue 应用实例
  
  // 配置顺序很重要：
  setupStore(app);          // 1. 状态管理
  initAppConfigStore();     // 2. 应用配置
  registerGlobComp(app);    // 3. 全局组件
  await setupI18n(app);     // 4. 国际化
  setupRouter(app);         // 5. 路由
  setupRouterGuard(router); // 6. 路由守卫
  setupGlobDirectives(app); // 7. 全局指令
  setupErrorHandle(app);    // 8. 错误处理
  
  app.mount('#app');        // 9. 挂载到 DOM
}

bootstrap();
