<template>
  <div class="upload-file-container" :class="$attrs.class">
    <template v-if="!detailed">
      <a-button preIcon="icon-ym icon-ym-btn-upload" :disabled="disabled" @click="uploadFile">{{ buttonText }}</a-button>
      <p @click="handleDownloadAll" class="link-text" v-if="fileList.length && showDownload"><DownloadOutlined />{{ t('component.upload.downloadAll') }}</p>
    </template>
    <div class="upload-file__tip" v-if="tipText && !detailed">{{ tipText }}</div>
    <div class="upload-file-list" :class="{ 'upload-file-list__simple': simple }" v-if="showUploadList">
      <div class="upload-file-list__item" v-for="(file, index) in fileList" :key="file.fileId" :class="{ 'upload-file-list__item_detail': detailed }">
        <a
          class="upload-file-list__item-name"
          :title="file.name + (file.fileSize && !simple ? '(' + toFileSize(file.fileSize) + ')' : '')"
          @click="handleSimplePreview(file)">
          <PaperClipOutlined v-if="showIcon" />
          {{ file.name }}{{ file.fileSize && !simple ? `(${toFileSize(file.fileSize)})` : '' }}
        </a>
        <span class="upload-file-list__item-actions">
          <EyeOutlined :title="t('component.upload.view')" @click="handlePreview(file)" v-if="showView" />
          <DownloadOutlined :title="t('component.upload.download')" @click="handleDownload(file)" v-if="showDownload" />
          <CloseOutlined :title="t('component.upload.del')" @click="handleRemove(index)" v-show="!disabled && !detailed" />
        </span>
      </div>
    </div>
    <Preview ref="filePreviewRef" :type="type" :showDownload="simple" />
    <FileUploader ref="fileUploaderRef" v-bind="getBindValue" @fileSuccess="handleFileSuccess" />
  </div>
</template>

<script lang="ts" setup>
  import { getDownloadUrl, getPackDownloadUrl } from '@/api/basic/common';
  import { computed, ref, unref, watch } from 'vue';
  import { Form } from 'ant-design-vue';
  import { PaperClipOutlined, EyeOutlined, DownloadOutlined, CloseOutlined } from '@ant-design/icons-vue';
  import { uploadFileProps, fileItem } from './props';
  import { useGlobSetting } from '@/hooks/setting';
  import { useMessage } from '@/hooks/web/useMessage';
  import { useI18n } from '@/hooks/web/useI18n';
  import { createImgPreview } from '@/components/Preview/index';
  import { toFileSize } from '@/utils/youyi';
  import { downloadByUrl } from '@/utils/file/download';
  import Preview from './Preview.vue';
  import FileUploader from './SimpleUploader/FileUploader.vue';

  defineOptions({ name: 'YouyiUploadFile', inheritAttrs: false });
  const props = defineProps(uploadFileProps);
  const emit = defineEmits(['update:value', 'change']);
  const { createMessage } = useMessage();
  const { t } = useI18n();
  const globSetting = useGlobSetting();
  const fileList = ref<fileItem[]>([]);
  const apiUrl = ref(globSetting.apiUrl);
  const videoTypeList = ['avi', 'wmv', 'mpg', 'mpeg', 'mov', 'rm', 'ram', 'swf', 'flv', 'mp4', 'mp3', 'wma', 'avi', 'rm', 'rmvb', 'flv', 'mpg', 'mkv'];
  const imgTypeList = ['png', 'jpg', 'jpeg', 'bmp', 'gif'];
  const zipTypeList = ['rar', 'zip', 'arj', 'z', '7z'];
  const filePreviewRef = ref<any>(null);
  const fileUploaderRef = ref<any>(null);
  const formItemContext = Form.useInjectFormItemContext();

  const getBindValue = computed(() => ({ ...props, value: fileList.value }));

  watch(
    () => props.value,
    val => {
      fileList.value = val && Array.isArray(val) ? val : [];
    },
    {
      deep: true,
      immediate: true,
    },
  );

  defineExpose({ uploadFile });

  function handleSimplePreview(file: fileItem) {
    if (!props.simple) return;
    handlePreview(file);
  }
  function handlePreview(file: fileItem) {
    if (videoTypeList.includes(file.fileExtension || '')) {
      createMessage.error(t('component.upload.videoNoPreview'));
      return;
    }
    if (zipTypeList.includes(file.fileExtension || '')) {
      createMessage.error(t('component.upload.zipNoPreview'));
      return;
    }
    // 图片预览
    if (imgTypeList.includes(file.fileExtension || '')) {
      const imageList = [ file.url];
      createImgPreview({ imageList: imageList });
      return;
    }
    // 文件预览
    filePreviewRef.value?.init(file);
  }
  function handleDownload(file: fileItem) {
    if (!file.fileId) return;
    getDownloadUrl(props.type, file.fileId).then(res => {
      downloadByUrl({ url: res.data.url, fileName: file.name });
    });
  }
  // 批量下载
  function handleDownloadAll() {
    let data: any[] = [];
    for (let i = 0; i < unref(fileList).length; i++) {
      data.push({ fileId: unref(fileList)[i].fileId, fileName: unref(fileList)[i].name });
    }
    getPackDownloadUrl(props.type, data).then(res => {
      if (!res.data && !res.data.downloadVo) return;
      downloadByUrl({ url: res.data.downloadVo.url, fileName: res.data.downloadName });
    });
  }
  function handleRemove(index: number) {
    fileList.value.splice(index, 1);
    emit('update:value', unref(fileList));
    emit('change', unref(fileList));
    formItemContext.onFieldChange();
  }
  function uploadFile() {
    const isTopLimit = props.limit ? fileList.value.length >= props.limit : false;
    if (isTopLimit) {
      createMessage.error(t('component.upload.fileMaxNumber', [props.limit]));
      return false;
    }
    fileUploaderRef.value?.openUploader();
  }
  function handleFileSuccess(data) {
    const isTopLimit = props.limit ? fileList.value.length >= props.limit : false;
    if (isTopLimit) {
      createMessage.error(t('component.upload.fileMaxNumber', [props.limit]));
      return false;
    }
    fileList.value.push(data);
    emit('update:value', unref(fileList));
    emit('change', unref(fileList));
    formItemContext.onFieldChange();
  }
</script>
<style lang="less" scoped>
  .upload-file-container {
    .link-text {
      float: right;
      line-height: 32px;
      .anticon {
        margin-right: 2px;
      }
    }
    .upload-file__tip {
      line-height: 1.2;
      color: @text-color-secondary;
      margin-top: 5px;
      font-size: 12px;
      word-break: break-all;
    }
    .upload-file-list {
      &.upload-file-list__simple {
        .upload-file-list__item {
          color: @primary-color;
          &:first-child {
            margin-top: 0 !important;
          }
          &:hover {
            background-color: unset !important;
          }
          .upload-file-list__item-name {
            margin-right: 0;
            padding-left: 0;
            .anticon {
              display: none;
            }
          }
          .anticon-eye,
          .anticon-download,
          .anticon-close {
            display: none;
          }
        }
      }
      .upload-file-list__item {
        font-size: 14px;
        color: @text-color-label;
        line-height: 26px;
        margin-top: 5px;
        position: relative;
        box-sizing: border-box;
        border-radius: 4px;
        width: 100%;
        a {
          color: inherit;
        }
        &:first-child {
          margin-top: 10px;
        }
        &:hover {
          background-color: @selected-hover-bg;
          .upload-file-list__item-name {
            color: @primary-color;
          }
        }
        &.upload-file-list__item_detail:first-child {
          margin-top: 0 !important;
        }
        .upload-file-list__item-name {
          margin-right: 70px;
          display: block;
          overflow: hidden;
          padding-left: 4px;
          text-overflow: ellipsis;
          white-space: nowrap;
          .anticon {
            height: 100%;
            margin-right: 5px;
            color: #909399;
          }
        }
        .anticon-eye {
          display: inline-block;
          position: absolute;
          top: 6px;
          right: 45px;
          cursor: pointer;
          opacity: 0.75;
          color: @text-color-label;
        }
        .anticon-download {
          display: inline-block;
          position: absolute;
          top: 6px;
          right: 25px;
          cursor: pointer;
          opacity: 0.75;
          color: @text-color-label;
        }

        .anticon-close {
          display: inline-block;
          position: absolute;
          top: 6px;
          right: 5px;
          cursor: pointer;
          opacity: 0.75;
          color: @text-color-label;
        }
      }
    }
    .list-enter-active,
    .list-leave-active {
      transition: all 1s ease;
    }
    .list-enter-from,
    .list-leave-to {
      opacity: 0;
      transform: translateY(-30px);
    }
  }
</style>
