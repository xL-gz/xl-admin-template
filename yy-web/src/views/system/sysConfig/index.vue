<template>
  <div class="youyi-content-wrapper">
    <div class="youyi-content-wrapper-center bg-white">
      <a-form :colon="false" :labelCol="{ style: { width: '100px' } }" class="right-board-form h-full" labelAlign="right">
        <a-tabs v-model:activeKey="activeKey" class="youyi-content-wrapper-tabs tabs-contain">
          <a-tab-pane :key="1" class="p-30px" tab="基本设置">
            <a-row>
              <a-col :span="24">
                <a-form-item label="系统图标">
                  <div class="system-icons-container">
                    <div class="icon-upload-item">
                      <div class="icon-upload-label">登录图标</div>
                      <YouyiUploadImgSingle v-model:value="baseForm.loginIcon" :tipText="baseForm.loginIcon ? '' : '上传图标'" />
                    </div>
                    <div class="icon-upload-item">
                      <div class="icon-upload-label">LOGO图标</div>
                      <YouyiUploadImgSingle v-model:value="baseForm.logoIcon" :tipText="baseForm.logoIcon ? '' : '上传图标'" />
                    </div>
                    <div class="icon-upload-item">
                      <div class="icon-upload-label">APP图标</div>
                      <YouyiUploadImgSingle v-model:value="baseForm.appIcon" :tipText="baseForm.appIcon ? '' : '上传图标'" />
                    </div>
                  </div>
                </a-form-item>
              </a-col>
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
          <a-tab-pane :key="3" class="p-30px" tab="文件存储配置">
            <a-tabs v-model:activeKey="storageTab" style="height: 100%" tab-position="left">
              <a-tab-pane :key="1" tab="OSS存储配置">
                <a-row>
                  <a-col :span="24">
                    <div class="storage-config-header">
                      <span class="storage-title">OSS对象存储配置</span>
                      <a-button type="primary" @click="addOssConfig">
                        <template #icon><PlusOutlined /></template>
                        添加OSS配置
                      </a-button>
                    </div>
                  </a-col>
                  <a-col :span="24" v-if="!baseForm.ossStorageConfigs || baseForm.ossStorageConfigs.length === 0">
                    <a-empty description="暂无OSS配置，点击上方按钮添加" />
                  </a-col>
                  <a-col :span="24" v-for="(ossConfig, index) in baseForm.ossStorageConfigs" :key="`oss-${index}`" class="storage-config-item">
                    <a-card :title="ossConfig.name || `OSS配置 ${index + 1}`" class="storage-card">
                      <template #extra>
                        <a-space>
                          <a-switch v-model:checked="ossConfig.enabled" checked-children="启用" un-checked-children="禁用" />
                          <a-button type="link" danger @click="removeOssConfig(index)">
                            <template #icon><DeleteOutlined /></template>
                            删除
                          </a-button>
                        </a-space>
                      </template>
                      <a-row :gutter="16">
                        <a-col :span="12">
                          <a-form-item label="配置名称">
                            <a-input v-model:value="ossConfig.name" placeholder="请输入配置名称" />
                          </a-form-item>
                        </a-col>
                        <a-col :span="12">
                          <a-form-item label="排序码">
                            <a-input-number v-model:value="ossConfig.sortCode" :min="0" placeholder="排序码" />
                          </a-form-item>
                        </a-col>
                        <a-col :span="12">
                          <a-form-item label="OSS Endpoint">
                            <a-input v-model:value="ossConfig.endpoint" placeholder="如: https://oss-cn-beijing.aliyuncs.com" />
                          </a-form-item>
                        </a-col>
                        <a-col :span="12">
                          <a-form-item label="OSS Region">
                            <a-input v-model:value="ossConfig.region" placeholder="如: cn-beijing" />
                          </a-form-item>
                        </a-col>
                        <a-col :span="12">
                          <a-form-item label="OSS Bucket">
                            <a-input v-model:value="ossConfig.bucketName" placeholder="存储桶名称" />
                          </a-form-item>
                        </a-col>
                        <a-col :span="12">
                          <a-form-item label="OSS 访问域名">
                            <a-input v-model:value="ossConfig.domain" placeholder="自定义域名（可选）" />
                          </a-form-item>
                        </a-col>
                        <a-col :span="12">
                          <a-form-item label="AccessKeyId">
                            <a-input-password v-model:value="ossConfig.accessKeyId" placeholder="OSS AccessKeyId" />
                          </a-form-item>
                        </a-col>
                        <a-col :span="12">
                          <a-form-item label="AccessKeySecret">
                            <a-input-password v-model:value="ossConfig.accessKeySecret" placeholder="OSS AccessKeySecret" />
                          </a-form-item>
                        </a-col>
                      </a-row>
                    </a-card>
                  </a-col>
                  <a-col :span="24">
                    <a-form-item label=" ">
                      <a-button :loading="btnLoading" type="primary" @click.prevent="handleSubmit">保存 </a-button>
                    </a-form-item>
                  </a-col>
                </a-row>
              </a-tab-pane>
              <a-tab-pane :key="2" tab="云服务器存储配置">
                <a-row>
                  <a-col :span="24">
                    <div class="storage-config-header">
                      <span class="storage-title">云服务器存储配置</span>
                      <a-button type="primary" @click="addCloudServerConfig">
                        <template #icon><PlusOutlined /></template>
                        添加云服务器配置
                      </a-button>
                    </div>
                  </a-col>
                  <a-col :span="24" v-if="!baseForm.cloudServerStorageConfigs || baseForm.cloudServerStorageConfigs.length === 0">
                    <a-empty description="暂无云服务器配置，点击上方按钮添加" />
                  </a-col>
                  <a-col :span="24" v-for="(cloudConfig, index) in baseForm.cloudServerStorageConfigs" :key="`cloud-${index}`" class="storage-config-item">
                    <a-card :title="cloudConfig.name || `云服务器配置 ${index + 1}`" class="storage-card">
                      <template #extra>
                        <a-space>
                          <a-switch v-model:checked="cloudConfig.enabled" checked-children="启用" un-checked-children="禁用" />
                          <a-button type="link" danger @click="removeCloudServerConfig(index)">
                            <template #icon><DeleteOutlined /></template>
                            删除
                          </a-button>
                        </a-space>
                      </template>
                      <a-row :gutter="16">
                        <a-col :span="12">
                          <a-form-item label="配置名称">
                            <a-input v-model:value="cloudConfig.name" placeholder="请输入配置名称" />
                          </a-form-item>
                        </a-col>
                        <a-col :span="12">
                          <a-form-item label="排序码">
                            <a-input-number v-model:value="cloudConfig.sortCode" :min="0" placeholder="排序码" />
                          </a-form-item>
                        </a-col>
                        <a-col :span="12">
                          <a-form-item label="服务器地址">
                            <a-input v-model:value="cloudConfig.serverAddress" placeholder="如: http://192.168.1.100:8080 或 https://files.example.com" />
                            <div class="common-tip mt-5px">云服务器的访问地址</div>
                          </a-form-item>
                        </a-col>
                        <a-col :span="12">
                          <a-form-item label="存储路径">
                            <a-input v-model:value="cloudConfig.storagePath" placeholder="如: /uploads 或 /var/www/uploads" />
                            <div class="common-tip mt-5px">服务器本地文件存储路径，建议使用绝对路径</div>
                          </a-form-item>
                        </a-col>
                        <a-col :span="12">
                          <a-form-item label="访问密钥">
                            <a-input-password v-model:value="cloudConfig.accessKey" placeholder="访问密钥（可选）" />
                            <div class="common-tip mt-5px">可选，用于访问服务器的认证</div>
                          </a-form-item>
                        </a-col>
                      </a-row>
                    </a-card>
                  </a-col>
                  <a-col :span="24">
                    <a-form-item label=" ">
                      <a-button :loading="btnLoading" type="primary" @click.prevent="handleSubmit">保存 </a-button>
                    </a-form-item>
                  </a-col>
                </a-row>
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
  import YouyiUploadImgSingle from '@/components/Youyi/Upload/src/UploadImgSingle.vue';
  import { PlusOutlined, DeleteOutlined } from '@ant-design/icons-vue';

  interface State {
    baseForm: any;
    activeKey: number;
    securityTab: number;
    storageTab: number;
    btnLoading: boolean;
  }

  defineOptions({ name: 'system-sysConfig' });

  const state = reactive<State>({
    baseForm: {},
    activeKey: 1,
    securityTab: 1,
    storageTab: 1,
    btnLoading: false,
  });

  const { baseForm, activeKey, securityTab, storageTab, btnLoading } = toRefs(state);
  const { createConfirm, createMessage } = useMessage();
  const { t } = useI18n();
  const appStore = useAppStore();

  function initData() {
    getSysConfig().then(res => {
      const data = res.data || {};
      // 确保数组字段被正确初始化
      if (!data.ossStorageConfigs) {
        data.ossStorageConfigs = [];
      }
      if (!data.cloudServerStorageConfigs) {
        data.cloudServerStorageConfigs = [];
      }
      state.baseForm = data;
      console.log('加载的数据:', JSON.stringify(data, null, 2));
      console.log('云服务器配置数量:', data.cloudServerStorageConfigs?.length || 0);
    }).catch(err => {
      console.error('获取系统配置失败:', err);
      // 即使失败也要初始化空数组
      state.baseForm = {
        ossStorageConfigs: [],
        cloudServerStorageConfigs: []
      };
    });
  }

  function handleSubmit() {
    createConfirm({
      iconType: 'warning',
      title: t('common.tipTitle'),
      content: '您确定要保存，是否继续?',
      onOk: () => {
        state.btnLoading = true;
        // 确保数组字段存在
        if (!state.baseForm.ossStorageConfigs) {
          state.baseForm.ossStorageConfigs = [];
        }
        if (!state.baseForm.cloudServerStorageConfigs) {
          state.baseForm.cloudServerStorageConfigs = [];
        }
        console.log('保存的数据:', JSON.stringify(state.baseForm, null, 2));
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
            // 保存后重新加载数据
            setTimeout(() => {
              initData();
            }, 300);
          })
          .catch((err) => {
            console.error('保存失败:', err);
            state.btnLoading = false;
            createMessage.error('保存失败，请检查控制台错误信息');
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

  // OSS存储配置相关方法
  function addOssConfig() {
    if (!state.baseForm.ossStorageConfigs) {
      state.baseForm.ossStorageConfigs = [];
    }
    state.baseForm.ossStorageConfigs.push({
      name: '',
      endpoint: '',
      accessKeyId: '',
      accessKeySecret: '',
      bucketName: '',
      region: '',
      domain: '',
      enabled: true,
      sortCode: state.baseForm.ossStorageConfigs.length,
    });
  }

  function removeOssConfig(index: number) {
    createConfirm({
      iconType: 'warning',
      title: '确认删除',
      content: '确定要删除这个OSS配置吗？',
      onOk: () => {
        state.baseForm.ossStorageConfigs.splice(index, 1);
      },
    });
  }

  // 云服务器存储配置相关方法
  function addCloudServerConfig() {
    if (!state.baseForm.cloudServerStorageConfigs) {
      state.baseForm.cloudServerStorageConfigs = [];
    }
    state.baseForm.cloudServerStorageConfigs.push({
      name: '',
      serverAddress: '',
      storagePath: '',
      accessKey: '',
      enabled: true,
      sortCode: state.baseForm.cloudServerStorageConfigs.length,
    });
  }

  function removeCloudServerConfig(index: number) {
    createConfirm({
      iconType: 'warning',
      title: '确认删除',
      content: '确定要删除这个云服务器配置吗？',
      onOk: () => {
        state.baseForm.cloudServerStorageConfigs.splice(index, 1);
      },
    });
  }

  onMounted(() => {
    const route = useRoute();
    if (route.query.type == '1') state.activeKey = 2;
    if (route.query.type == '2') state.activeKey = 3;
    initData();
  });
</script>
<style lang="less" scoped>
  .common-tip {
    color: @text-color-secondary;
    font-size: 14px;
    line-height: 1;
  }

  .system-icons-container {
    display: flex;
    gap: 40px;
    flex-wrap: wrap;

    .icon-upload-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 12px;

      .icon-upload-label {
        font-size: 14px;
        color: @text-color;
        font-weight: 500;
      }

      :deep(.single-img-container) {
        width: 120px;
        height: 120px;

        .ant-upload-list-picture-card-container,
        .img-uploader .ant-upload {
          width: 120px;
          height: 120px;
        }
      }
    }
  }

  .storage-config-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 1px solid #f0f0f0;

    .storage-title {
      font-size: 16px;
      font-weight: 500;
      color: @text-color;
    }
  }

  .storage-config-item {
    margin-bottom: 20px;

    .storage-card {
      :deep(.ant-card-head-title) {
        font-weight: 500;
      }
    }
  }
</style>
