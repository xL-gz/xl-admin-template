<template>
  <div class="login-cap">{{ t('sys.login.welcome') }}</div>
  <div class="login-sub-title">{{ t('sys.login.subTitle') }}</div>

  <Form class="enter-x" :model="formData" :rules="getFormRules" ref="formRef">
    <FormItem name="account" class="enter-x">
      <Input size="large" v-model:value="formData.account" :placeholder="t('sys.login.username')" class="fix-auto-fill" />
    </FormItem>
    <FormItem name="password" class="enter-x">
      <InputPassword size="large" v-model:value="formData.password" :placeholder="t('sys.login.password')" />
    </FormItem>
    
    <div class="pt-10px">
      <FormItem class="enter-x">
        <Button type="primary" size="large" block @click="handleLogin" :loading="loading">
          {{ t('sys.login.loginButton') }}
        </Button>
      </FormItem>
    </div>
  </Form>
</template>

<script lang="ts" setup>
  import { reactive, ref } from 'vue';
  import { Form, Input, Button, message } from 'ant-design-vue';
  import { useI18n } from '@/hooks/web/useI18n';
  import { useUserStore } from '@/store/modules/user';
  import { useFormRules, useFormValid } from './useLogin';
  import { useRouter } from 'vue-router';
  import { PageEnum } from '@/enums/pageEnum';

  const FormItem = Form.Item;
  const InputPassword = Input.Password;

  const { t } = useI18n();
  const userStore = useUserStore();
  const router = useRouter();

  const formRef = ref();
  const loading = ref(false);

  const formData = reactive({
    account: 'admin',
    password: '123456',
  });

  const { getFormRules } = useFormRules();
  const { validForm } = useFormValid(formRef);

  // 静态登录 - 模拟登录逻辑
  async function handleLogin() {
    const data = await validForm();
    if (!data) return;

    try {
      loading.value = true;

      // 静态验证：admin/123456 或 test/123456
      if (
        (data.account === 'admin' && data.password === '123456') ||
        (data.account === 'test' && data.password === '123456')
      ) {
        // 模拟token
        const mockToken = 'mock-token-' + Date.now();
        
        // 设置token
        userStore.setToken(mockToken);
        
        // 模拟用户信息
        const mockUserInfo = {
          userId: data.account === 'admin' ? '1' : '2',
          userAccount: data.account,
          userName: data.account === 'admin' ? '系统管理员' : '测试用户',
          headIcon: '',
          email: data.account + '@xl.com',
          mobilePhone: '13800138000',
          birthday: null,
          isAdministrator: data.account === 'admin',
          departmentId: 'dept_001',
          departmentName: '技术部',
          organizeId: 'org_001',
          organizeName: 'XL科技有限公司',
          organizeIdList: ['org_001'],
          positionId: 'pos_001',
          positionName: 'Java工程师',
          positionIds: ['pos_001'],
          manager: null,
          roleName: data.account === 'admin' ? '超级管理员' : '普通用户',
          roleIds: data.account === 'admin' ? ['1'] : ['2'],
          groupIds: [],
          prevLogin: Date.now(),
          prevLoginTime: Date.now(),
          prevLoginIPAddress: '127.0.0.1',
          prevLoginIPAddressName: '本地',
          systemId: 'sys_001',
          systemIds: [],
          portalId: '',
          signImg: '',
          signId: '',
          standingList: [],
        };

        // 模拟系统配置
        const mockSysConfig = {
          appIcon: '/resource/img/logo.png',
          companyName: 'XL科技有限公司',
          copyright: 'Copyright © 2024 XL Tech',
          loginIcon: '/resource/img/logo.png',
          logoIcon: '/resource/img/logo.png',
          navigationIcon: '/resource/img/logo.png',
          workLogoIcon: '/resource/img/logo.png',
          newUserDefaultPassword: '123456',
          sysName: 'XL-IM',
          sysVersion: '1.0.0',
          title: 'XL即时通讯系统',
          youyiDomain: '',
          defaultView: 'classic',
          showLunarCalendar: false,
          firstDay: 1,
          duration: 2,
        };

        // 模拟菜单数据
        const mockMenuList = [
          {
            id: '1',
            enCode: 'dashboard',
            fullName: '工作台',
            icon: 'icon-ym icon-ym-nav-workbench',
            linkTarget: '_self',
            parentId: '0',
            hasChildren: false,
            propertyJson: '{}',
            sortCode: 100000,
            type: 2,
            urlAddress: '/dashboard',
            path: '/dashboard',
            children: null,
          },
          {
            id: '6',
            enCode: 'system',
            fullName: '系统管理',
            icon: 'icon-ym icon-ym-nav-systemSettings',
            linkTarget: '_self',
            parentId: '0',
            hasChildren: true,
            propertyJson: '{}',
            sortCode: 600000,
            type: 1,
            urlAddress: null,
            path: '/system',
            children: [
              {
                id: '7',
                enCode: 'system_user',
                fullName: '用户管理',
                icon: 'icon-ym icon-ym-generator-user',
                linkTarget: '_self',
                parentId: '6',
                hasChildren: false,
                propertyJson: '{}',
                sortCode: 600100,
                type: 2,
                urlAddress: '/system/permission/user',
                path: '/system/permission/user',
              },
              {
                id: '8',
                enCode: 'system_role',
                fullName: '角色管理',
                icon: 'icon-ym icon-ym-generator-role',
                linkTarget: '_self',
                parentId: '6',
                hasChildren: false,
                propertyJson: '{}',
                sortCode: 600200,
                type: 2,
                urlAddress: '/system/permission/role',
                path: '/system/permission/role',
              },
              {
                id: '9',
                enCode: 'system_menu',
                fullName: '菜单管理',
                icon: 'icon-ym icon-ym-generator-menu',
                linkTarget: '_self',
                parentId: '6',
                hasChildren: false,
                propertyJson: '{}',
                sortCode: 600300,
                type: 2,
                urlAddress: '/system/system/menu',
                path: '/system/system/menu',
              },
              {
                id: '10',
                enCode: 'system_config',
                fullName: '系统配置',
                icon: 'icon-ym icon-ym-generator-setup',
                linkTarget: '_self',
                parentId: '6',
                hasChildren: false,
                propertyJson: '{}',
                sortCode: 600400,
                type: 2,
                urlAddress: '/system/system/sysConfig',
                path: '/system/system/sysConfig',
              },
            ],
          },
        ];

        // 模拟权限数据
        const mockPermissionList = [];

        // 设置到store
        userStore.setUserInfo(mockUserInfo);
        userStore.setPermissionList(mockPermissionList);
        userStore.setBackMenuList(mockMenuList);
        userStore.setBackRouterList(mockMenuList);

        message.success(t('sys.login.loginSuccessTitle'));

        // 跳转到首页
        setTimeout(() => {
          router.push(PageEnum.BASE_HOME);
        }, 200);
      } else {
        message.error('用户名或密码错误！请使用 admin/123456 或 test/123456');
      }
    } catch (error: any) {
      message.error(error.message || t('sys.api.operationFailed'));
    } finally {
      loading.value = false;
    }
  }
</script>
