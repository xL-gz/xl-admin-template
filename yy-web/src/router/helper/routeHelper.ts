import type { AppRouteModule, AppRouteRecordRaw } from '@/router/types';
import type { Router, RouteRecordNormalized } from 'vue-router';
import { PageEnum } from '@/enums/pageEnum';

import { getParentLayout, LAYOUT, EXCEPTION_COMPONENT } from '@/router/constant';
import { cloneDeep, omit } from 'lodash-es';
import { warn } from '@/utils/log';
import { createRouter, createWebHashHistory } from 'vue-router';
import { defineComponent, defineAsyncComponent, h } from 'vue';
import { BackMenu } from '@/api/basic/model/userModel';

export type LayoutMapKey = 'LAYOUT';
const IFRAME = () => import('@/views/basic/iframe/FrameBlank.vue');
// 注释掉不存在的组件引用
// const ONLINE_MODEL = () => import('@/views/common/dynamicModel/index.vue');
// const ONLINE_DICT = () => import('@/views/common/dynamicDictionary/index.vue');
// const ONLINE_REPORT = () => import('@/views/common/dynamicDataReport/index.vue');
// const ONLINE_PORTAL = () => import('@/views/common/dynamicPortal/index.vue');

const LayoutMap = new Map<string, () => Promise<typeof import('*.vue')>>();

LayoutMap.set('LAYOUT', LAYOUT);
LayoutMap.set('IFRAME', IFRAME);
// 注释掉不存在的组件映射
// LayoutMap.set('ONLINE_MODEL', ONLINE_MODEL);
// LayoutMap.set('ONLINE_DICT', ONLINE_DICT);
// LayoutMap.set('ONLINE_REPORT', ONLINE_REPORT);
// LayoutMap.set('ONLINE_PORTAL', ONLINE_PORTAL);

let dynamicViewsModules: Record<string, () => Promise<Recordable>>;

/**
 * 将指定组件设置自定义名称
 *
 * @param {String} name 组件自定义名称
 * @param {AsyncComponent} component
 * @return {Component}
 */
function createCustomComponent(customName, asyncComponent) {
  return defineComponent({
    name: customName,
    setup() {
      return () => h(asyncComponent);
    },
  });
}

// Dynamic introduction
function asyncImportRoute(routes: AppRouteRecordRaw[] | undefined) {
  dynamicViewsModules = dynamicViewsModules || import.meta.glob('../../views/**/*.{vue,tsx}');
  if (!routes) return;
  routes.forEach(item => {
    if (!item.component && item.meta?.frameSrc) {
      item.component = 'IFRAME';
    }
    const { component, name } = item;
    const { children } = item;
    if (component) {
      const layoutFound = LayoutMap.get(component.toUpperCase());
      if (layoutFound) {
        item.component = ['LAYOUT', 'IFRAME'].includes(component) ? layoutFound : createCustomComponent(name, defineAsyncComponent(layoutFound));
      } else {
        item.component = dynamicImport(dynamicViewsModules, component as string);
      }
    } else if (name) {
      item.component = getParentLayout();
    }
    children && asyncImportRoute(children);
  });
}

function dynamicImport(dynamicViewsModules: Record<string, () => Promise<Recordable>>, component: string) {
  const keys = Object.keys(dynamicViewsModules);

  const matchKeys = keys.filter(key => {
    const k = key.replace('../../views', '');
    const startFlag = component.startsWith('/');
    const endFlag = component.endsWith('.vue') || component.endsWith('.tsx');
    const startIndex = startFlag ? 0 : 1;
    const lastIndex = endFlag ? k.length : k.lastIndexOf('.');
    return k.substring(startIndex, lastIndex) === component || k.substring(startIndex, lastIndex) === component + '/index';
  });
  if (matchKeys?.length === 1) {
    const matchKey = matchKeys[0];
    return dynamicViewsModules[matchKey];
  } else if (matchKeys?.length > 1) {
    warn(
      'Please do not create `.vue` and `.TSX` files with the same file name in the same hierarchical directory under the views folder. This will cause dynamic introduction failure',
    );
    return;
  } else {
    // warn('在src/views/下找不到`' + component + '.vue` 或 `' + component + '.tsx`, 请自行创建!');
    return EXCEPTION_COMPONENT;
  }
}

// Turn background objects into routing objects
// 将背景对象变成路由对象
export function transformObjToRoute<T = AppRouteModule>(routerList: BackMenu[]): T[] {
  const routeList: AppRouteModule[] = [];

  /**
   * 递归处理菜单列表，生成路由
   * @param menuList 菜单列表
   * @param parentPath 父路径（用于构建子路由的完整路径）
   */
  function getRouteList(menuList: any[], parentPath = '') {
    for (let i = 0; i < menuList.length; i++) {
      const menu = menuList[i];
      const name = menu.enCode.replace(/\./g, '-');

      // type = 0: 分组（暂不处理）
      // type = 1: 目录（分组容器，没有实际页面，但需要创建路由以支持子菜单显示）
      // type = 2: 菜单/页面（实际的路由页面）

      // 处理目录类型（type=1/M）- 创建虚拟路由以支持子菜单显示
      if (menu.type === 1 || menu.menuType === 'M') {
        // 确保path设置正确
        if (!menu.path || !menu.path.startsWith('/')) {
          menu.path = '/' + menu.enCode;
        }
        
        // 处理子菜单
        if (menu.hasChildren && menu.children && menu.children.length > 0) {
          getRouteList(menu.children, menu.path);
        }
        
        continue; // 目录不添加到路由列表，它只是用来组织结构
      }

      // 处理菜单/页面类型（type=2/C）- 创建实际路由
      if (menu.type === 2 || menu.menuType === 'C') {
        // 如果有urlAddress就用urlAddress，否则用component
        const componentPath = menu.urlAddress || menu.component;
        if (!componentPath) {
          console.warn(`菜单 ${menu.fullName} 缺少组件路径`);
          continue;
        }

        // 处理带查询参数的路径
        let path = componentPath;
        if (path.indexOf('?') > -1) {
          path = path.split('?')[0];
        }

        // 设置菜单的path（用于菜单显示）
        menu.path = '/' + path;

        // 创建路由对象
        const route: AppRouteModule = {
          path: '/' + path,
          component: componentPath, // 组件路径
          name: name,
          meta: {
            title: 'routes.' + name,
            defaultTitle: menu.fullName || menu.menuName,
            icon: menu.icon || '',
            modelId: menu.id,
          },
        };

        routeList.push(route);

        // 如果有子菜单，递归处理
        if (menu.hasChildren && menu.children && menu.children.length > 0) {
          getRouteList(menu.children, menu.path);
        }
        continue;
      }

      // 处理分组类型（type=0）- 只递归处理children
      if (menu.type === 0) {
        if (menu.hasChildren && menu.children && menu.children.length > 0) {
          getRouteList(menu.children, parentPath);
        }
        continue;
      }

      // 如果是其他类型，暂时跳过（保留原有逻辑的注释）
      // 表单、字典、报表、门户、流程、大屏、外链等类型在简化版本中暂不支持
      console.warn(`暂不支持的菜单类型: ${menu.type}, 菜单名称: ${menu.fullName || menu.menuName}`);
    }
  }

  getRouteList(routerList);
  asyncImportRoute(routeList);

  const RootRoute: AppRouteRecordRaw = {
    path: '/asyncRoutes',
    name: 'asyncRoutes',
    redirect: PageEnum.BASE_HOME,
    component: LAYOUT,
    meta: {
      title: 'asyncRoutes',
    },
    children: routeList,
  };
  const asyncRouteList: AppRouteRecordRaw[] = [RootRoute];

  return asyncRouteList as unknown as T[];
}

/**
 * Convert multi-level routing to level 2 routing
 * 将多级路由转换为 2 级路由
 */
export function flatMultiLevelRoutes(routeModules: AppRouteModule[]) {
  const modules: AppRouteModule[] = cloneDeep(routeModules);

  for (let index = 0; index < modules.length; index++) {
    const routeModule = modules[index];
    // 判断级别是否 多级 路由
    if (!isMultipleRoute(routeModule)) {
      // 声明终止当前循环， 即跳过此次循环，进行下一轮
      continue;
    }
    // 路由等级提升
    promoteRouteLevel(routeModule);
  }
  return modules;
}

// Routing level upgrade
// 路由等级提升
function promoteRouteLevel(routeModule: AppRouteModule) {
  // Use vue-router to splice menus
  // 使用vue-router拼接菜单
  // createRouter 创建一个可以被 Vue 应用程序使用的路由实例
  let router: Router | null = createRouter({
    routes: [routeModule as unknown as RouteRecordNormalized],
    history: createWebHashHistory(),
  });
  // getRoutes： 获取所有 路由记录的完整列表。
  const routes = router.getRoutes();
  // 将所有子路由添加到二级路由
  addToChildren(routes, routeModule.children || [], routeModule);
  router = null;

  // omit lodash的函数 对传入的item对象的children进行删除
  routeModule.children = routeModule.children?.map(item => omit(item, 'children'));
}

// Add all sub-routes to the secondary route
// 将所有子路由添加到二级路由
function addToChildren(routes: RouteRecordNormalized[], children: AppRouteRecordRaw[], routeModule: AppRouteModule) {
  for (let index = 0; index < children.length; index++) {
    const child = children[index];
    const route = routes.find(item => item.name === child.name);
    if (!route) {
      continue;
    }
    routeModule.children = routeModule.children || [];
    if (!routeModule.children.find(item => item.name === route.name)) {
      routeModule.children?.push(route as unknown as AppRouteModule);
    }
    if (child.children?.length) {
      addToChildren(routes, child.children, routeModule);
    }
  }
}

// Determine whether the level exceeds 2 levels
// 判断级别是否超过2级
function isMultipleRoute(routeModule: AppRouteModule) {
  // Reflect.has 与 in 操作符 相同, 用于检查一个对象(包括它原型链上)是否拥有某个属性
  if (!routeModule || !Reflect.has(routeModule, 'children') || !routeModule.children?.length) {
    return false;
  }

  const children = routeModule.children;

  let flag = false;
  for (let index = 0; index < children.length; index++) {
    const child = children[index];
    if (child.children?.length) {
      flag = true;
      break;
    }
  }
  return flag;
}
