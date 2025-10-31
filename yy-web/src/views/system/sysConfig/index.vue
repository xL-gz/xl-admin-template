<template>
  <div class="youyi-content-wrapper">
    <div class="youyi-content-wrapper-center bg-white">
      <a-form :colon="false" :labelCol="{ style: { width: '100px' } }" class="right-board-form h-full" labelAlign="right">
        <a-tabs v-model:activeKey="activeKey" class="youyi-content-wrapper-tabs tabs-contain">
          <a-tab-pane :key="1" class="p-30px" tab="基本设置">
            <a-row>
              <a-col :span="24">
                <a-form-item label="系统标题">
                  <a-input v-model:value="baseForm.title" allowClear placeholder="请输入" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="系统名称">
                  <a-input v-model:value="baseForm.sysName" allowClear placeholder="请输入" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="系统版本">
                  <a-input v-model:value="baseForm.sysVersion" allowClear placeholder="请输入" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="公司名称">
                  <a-input v-model:value="baseForm.companyName" allowClear placeholder="请输入" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="版权信息">
                  <a-input v-model:value="baseForm.copyright" allowClear placeholder="请输入" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="公司简称">
                  <a-input v-model:value="baseForm.companyCode" allowClear placeholder="请输入" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="公司地址">
                  <a-input v-model:value="baseForm.companyAddress" allowClear placeholder="请输入" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="公司法人">
                  <a-input v-model:value="baseForm.companyContacts" allowClear placeholder="请输入" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="公司电话">
                  <a-input v-model:value="baseForm.companyTelePhone" allowClear placeholder="请输入" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="公司邮箱">
                  <a-input v-model:value="baseForm.companyEmail" allowClear placeholder="请输入" />
                </a-form-item>
              </a-col>
              <a-col :span="24">
                <a-form-item label="系统描述">
                  <a-textarea v-model:value="baseForm.sysDescription" :autoSize="{ minRows: 5, maxRows: 10 }" placeholder="请输入" />
                </a-form-item>
              </a-col>
              <a-form-item label=" ">
                <a-button :loading="btnLoading" type="primary" @click.prevent="handleSubmit">保存 </a-button>
              </a-form-item>
            </a-row>
          </a-tab-pane>
          <a-tab-pane :key="2" class="p-30px" tab="安全设置">
            <a-tabs v-model:activeKey="securityTab" style="height: 100%" tab-position="left">
              <a-tab-pane :key="1" tab="登录策略">
                <a-row>
                  <a-col :span="8">
                    <a-form-item label="超时登出">
                      <a-input-number
                        v-model:value="baseForm.tokenTimeout"
                        :min="1"
                        :precision="0"
                        addonAfter="分钟"
                        @change="onNumberChange($event, 'tokenTimeout')" />
                    </a-form-item>
                    <a-form-item label="密码错误次数">
                      <a-input-number
                        v-model:value="baseForm.passwordErrorsNumber"
                        :min="1"
                        :precision="0"
                        addonAfter="次"
                        @change="onNumberChange($event, 'passwordErrorsNumber')" />
                    </a-form-item>
                  </a-col>
                </a-row>
                <div class="common-tip ml-100px"> 输入密码错误将用户锁定，设置3以下值表示不启动该功能 </div>
                <a-row>
                  <a-col :span="8">
                    <a-form-item label="白名单验证">
                      <youyi-switch v-model:value="baseForm.whitelistSwitch" />
                    </a-form-item>
                  </a-col>
                </a-row>
                <a-row>
                  <a-col :span="12">
                    <a-form-item v-if="baseForm.whitelistSwitch" label="白名单设置">
                      <a-textarea v-model:value="baseForm.whiteListIp" :autoSize="{ minRows: 3, maxRows: 10 }" placeholder="允许访问IP" />
                      <div class="common-tip mt-10px"> 多个IP设置，用英文符号隔开，如192.168.0.1,192.168.0.2 </div>
                    </a-form-item>
                  </a-col>
                </a-row>
                <a-form-item label=" ">
                  <a-button :loading="btnLoading" type="primary" @click.prevent="handleSubmit"> 保存 </a-button>
                </a-form-item>
              </a-tab-pane>
              <a-tab-pane :key="2" tab="密码策略">
                <a-row>
                  <a-col :span="8">
                    <a-form-item :labelCol="{ style: { width: '120px' } }" label="密码强度限制">
                      <youyi-switch v-model:value="baseForm.passwordStrengthLimit" />
                    </a-form-item>
                  </a-col>
                </a-row>
                <a-row>
                  <a-col :span="10">
                    <a-form-item v-if="baseForm.passwordStrengthLimit" :labelCol="{ style: { width: '120px' } }" label=" ">
                      <div class="flex">
                        <YouyiCheckboxSingle v-model:value="baseForm.passwordLengthMin" class="checkbox mr-20px" label="最小长度" />
                        <a-input-number
                          v-model:value="baseForm.passwordLengthMinNumber"
                          :min="1"
                          :precision="0"
                          @change="onNumberChange($event, 'passwordLengthMinNumber')" />
                        <br />
                      </div>
                      <YouyiCheckboxSingle v-model:value="baseForm.containsNumbers" class="checkbox" label="包含数字" />
                      <br />
                      <YouyiCheckboxSingle v-model:value="baseForm.includeLowercaseLetters" class="checkbox" label="包含小写字母" />
                      <br />
                      <YouyiCheckboxSingle v-model:value="baseForm.includeUppercaseLetters" class="checkbox" label="包含大写字母" />
                      <br />
                      <YouyiCheckboxSingle v-model:value="baseForm.containsCharacters" class="checkbox" label="包含字符" />
                    </a-form-item>
                  </a-col>
                </a-row>
                <a-row>
                  <a-col :span="8">
                    <a-form-item :labelCol="{ style: { width: '120px' } }" label="修改初始密码提醒">
                      <youyi-switch v-model:value="baseForm.mandatoryModificationOfInitialPassword" />
                    </a-form-item>
                    <a-form-item :labelCol="{ style: { width: '120px' } }">
                      <template #label
                        >新用户默认密码
                        <BasicHelp text="修改后，新的默认密码仅针对后续新建的用户有效" />
                      </template>
                      <a-input v-model:value="baseForm.newUserDefaultPassword" placeholder="请输入" @change="handleDefaultPasswordChange" />
                    </a-form-item>
                  </a-col>
                </a-row>
                <a-form-item :labelCol="{ style: { width: '120px' } }" label=" ">
                  <a-button :loading="btnLoading" type="primary" @click.prevent="handleSubmit"> 保存 </a-button>
                </a-form-item>
              </a-tab-pane>
            </a-tabs>
          </a-tab-pane>
        </a-tabs>
      </a-form>
    </div>
  </div>
</template>
<script lang="ts" setup>
  import { onMounted, reactive, toRefs } from 'vue';
  import { useMessage } from '@/hooks/web/useMessage';
  import { useI18n } from '@/hooks/web/useI18n';
  import { useAppStore } from '@/store/modules/app';
  import { getSysConfig, update } from '@/api/system/sysConfig';
  import { useRoute } from 'vue-router';
  import YouyiSwitch from '@/components/Youyi/Switch/src/Switch.vue';

  interface State {
    baseForm: any;
    activeKey: number;
    securityTab: number;
    btnLoading: boolean;
  }

  defineOptions({ name: 'system-sysConfig' });

  const state = reactive<State>({
    baseForm: {},
    activeKey: 1,
    securityTab: 1,
    btnLoading: false,
  });

  const { baseForm, activeKey, securityTab, btnLoading } = toRefs(state);
  const { createConfirm, createMessage } = useMessage();
  const { t } = useI18n();
  const appStore = useAppStore();

  function initData() {
    getSysConfig().then(res => {
      state.baseForm = res.data || {};
    });
  }

  function handleSubmit() {
    createConfirm({
      iconType: 'warning',
      title: t('common.tipTitle'),
      content: '您确定要保存，是否继续?',
      onOk: () => {
        state.btnLoading = true;
        update(state.baseForm)
          .then(res => {
            createMessage.success(res.msg);
            state.btnLoading = false;
            const sysConfigInfo = {
              sysName: state.baseForm.sysName,
              sysVersion: state.baseForm.sysVersion,
              copyright: state.baseForm.copyright,
              newUserDefaultPassword: state.baseForm.newUserDefaultPassword,
              companyName: state.baseForm.companyName,
              title: state.baseForm.title,
            };
            appStore.setProjectConfig({ sysConfigInfo });
            initData();
          })
          .catch(() => {
            state.btnLoading = false;
          });
      },
    });
  }

  function onNumberChange(val, key) {
    if (val) return;
    state.baseForm[key] = 1;
  }

  function handleDefaultPasswordChange(e) {
    if (e.target.value) return;
    state.baseForm.newUserDefaultPassword = '0000';
  }

  onMounted(() => {
    const route = useRoute();
    if (route.query.type == '1') state.activeKey = 2;
    initData();
  });
</script>
<style lang="less" scoped>
  .common-tip {
    color: @text-color-secondary;
    font-size: 14px;
    line-height: 1;
  }
</style>
