<template>
  <BasicModal
    v-bind="$attrs"
    @register="registerModal"
    title="批量导入"
    :width="1000"
    :show-cancel-btn="false"
    :show-ok-btn="false"
    destroyOnClose
    class="youyi-import-modal">
    <div class="import-main">
      <div class="upload">
        <div class="up_left">
          <img src="@/assets/images/upload.png" />
        </div>
        <div class="up_right !pt-16px">
          <p class="title">上传填好的翻译文档</p>
          <p class="tip !my-10px">文件后缀名必须是xls或xlsx，文件大小不超过500KB，最多支持导入1000条数据</p>
          <p class="tip !my-10px">若文档中的翻译标记已存在库中则直接更新</p>
          <a-upload
            v-model:file-list="fileList"
            class="upload-area"
            accept=".xls,.xlsx"
            :max-count="1"
            :action="getAction"
            :headers="getHeaders"
            :before-upload="beforeUpload"
            @remove="handleFileRemove"
            @change="handleFileChange">
            <a-button type="link">上传文件</a-button>
          </a-upload>
        </div>
      </div>
      <div class="upload">
        <div class="up_left">
          <img src="@/assets/images/import.png" />
        </div>
        <div class="up_right">
          <p class="title">填写翻译文档</p>
          <p class="tip">请按照数据模板的格式准备导入数据，模板中的表头名称不可更改，表头行不能删除</p>
          <a-button type="link" @click="handleTemplateDownload()">下载模板</a-button>
        </div>
      </div>
    </div>
    <template #insertFooter>
      <a-button @click="closeModal()">{{ t('common.cancelText') }}</a-button>
      <a-button type="primary" @click="handleImport" :loading="btnLoading" :disabled="!fileName">上传</a-button>
    </template>
  </BasicModal>
</template>
<script lang="ts" setup>
  import { reactive, toRefs, computed } from 'vue';
  import { BasicModal, useModalInner } from '@/components/Modal';
  import { useMessage } from '@/hooks/web/useMessage';
  import { useI18n } from '@/hooks/web/useI18n';
  import { downloadByUrl } from '@/utils/file/download';
  import { useGlobSetting } from '@/hooks/setting';
  import { getToken } from '@/utils/auth';
  import { Upload as AUpload } from 'ant-design-vue';
  import type { UploadChangeParam, UploadFile } from 'ant-design-vue';
  import { templateDownload, importData } from '@/api/system/baseLang';

  interface State {
    fileName: string;
    fileList: UploadFile[];
    btnLoading: boolean;
  }

  const state = reactive<State>({
    fileName: '',
    fileList: [],
    btnLoading: false,
  });
  const { fileName, fileList, btnLoading } = toRefs(state);
  const emit = defineEmits(['register', 'reload']);
  const [registerModal, { closeModal }] = useModalInner(init);
  const { createMessage, createConfirm } = useMessage();
  const { t } = useI18n();
  const globSetting = useGlobSetting();

  const getAction = computed(() => globSetting.apiUrl + '/api/system/BaseLang/Uploader');
  const getHeaders = computed(() => ({ Authorization: getToken() as string }));

  function init() {
    state.fileName = '';
    state.fileList = [];
    state.btnLoading = false;
  }
  function handleImport() {
    if (!state.fileList.length || !state.fileName) return createMessage.warning('请先上传文件');
    state.btnLoading = true;
    importData({ fileName: state.fileName })
      .then(res => {
        state.btnLoading = false;
        createMessage.success(res.msg);
        emit('reload');
        closeModal();
      })
      .catch(() => {
        state.btnLoading = false;
      });
    return;
  }
  function handleFileChange({ file }: UploadChangeParam) {
    if (file.status === 'error') {
      createMessage.error('上传失败');
      return;
    }
    if (file.status === 'done') {
      if (file.response.code === 200) {
        state.fileName = file.response.data.name;
      } else {
        createMessage.error(file.response.msg);
      }
    }
  }
  function beforeUpload(file) {
    const fileType = file.name.replace(/.+\./, '');
    const isAccept = ['xls', 'xlsx'].indexOf(fileType.toLowerCase()) !== -1;
    if (!isAccept) {
      createMessage.error('文件格式不正确');
      return AUpload.LIST_IGNORE;
    }
    const isRightSize = file.size / 1024 < 500;
    if (!isRightSize) {
      createMessage.error('文件大小超过500KB');
      return AUpload.LIST_IGNORE;
    }
    return true;
  }
  function handleFileRemove(file) {
    return new Promise<void>((resolve, reject) => {
      createConfirm({
        iconType: 'warning',
        title: t('common.tipTitle'),
        content: `确定移除${file.name}?`,
        onOk: () => {
          state.fileName = '';
          resolve();
        },
        onCancel: () => {
          reject();
        },
      });
    });
  }
  function handleTemplateDownload() {
    templateDownload().then(res => {
      downloadByUrl({ url: res.data?.url });
    });
  }
</script>
