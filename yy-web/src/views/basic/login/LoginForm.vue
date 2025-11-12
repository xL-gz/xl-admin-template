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

  // 真实登录 - 调用后端API
  async function handleLogin() {
    const data = await validForm();
    if (!data) return;

    try {
      loading.value = true;
      
      // 调用后端登录接口
      const userInfo = await userStore.login({
        account: data.account,
        password: data.password,
        goHome: true,
        mode: 'modal',
      });

      if (userInfo) {
        message.success(t('sys.login.loginSuccessTitle'));
      }
    } catch (error: any) {
      message.error(error.message || t('sys.api.operationFailed'));
    } finally {
      loading.value = false;
    }
  }
</script>
