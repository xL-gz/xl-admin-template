<template>
  <div class="single-img-container">
    <div class="ant-upload-list ant-upload-list-picture-card" v-if="imageUrl">
      <div class="ant-upload-list-picture-card-container">
        <div class="ant-upload-list-item ant-upload-list-item-done ant-upload-list-item-list-type-picture-card">
          <div class="ant-upload-list-item-info">
            <a class="ant-upload-list-item-thumbnail">
              <img :src="getImageUrl(imageUrl)" class="ant-upload-list-item-image" />
            </a>
          </div>
          <span class="ant-upload-list-item-actions">
            <EyeOutlined @click="handlePreview" />
            <DeleteOutlined @click="handleRemove" v-if="!disabled" />
          </span>
        </div>
      </div>
    </div>
    <a-upload
      :class="$attrs.class"
      v-model:file-list="fileList"
      list-type="picture-card"
      class="img-uploader"
      :accept="accept"
      :disabled="disabled"
      :show-upload-list="false"
      :action="getAction"
      :headers="getHeaders"
      :before-upload="beforeUpload"
      @change="handleChange"
      v-else>
      <div>
        <loading-outlined v-if="loading" />
        <plus-outlined v-else />
        <div class="ant-upload-text" v-if="tipText">{{ tipText }}</div>
        <div class="ant-upload-text ant-upload-sub-text" v-if="subTipText">{{ subTipText }}</div>
      </div>
    </a-upload>
  </div>
</template>

<script lang="ts" setup>
  import { Form, Upload as AUpload } from 'ant-design-vue';
  import { PlusOutlined, LoadingOutlined, EyeOutlined, DeleteOutlined } from '@ant-design/icons-vue';
  import type { UploadChangeParam, UploadFile } from 'ant-design-vue';
  import { computed, ref, unref, watch } from 'vue';
  import { useGlobSetting } from '@/hooks/setting';
  import { getToken } from '@/utils/auth';
  import { useMessage } from '@/hooks/web/useMessage';
  import { useI18n } from '@/hooks/web/useI18n';
  import { createImgPreview } from '@/components/Preview/index';
  import { uploadImgSingleProps, units } from './props';

  defineOptions({ name: 'YouyiUploadImgSingle', inheritAttrs: false });
  const props = defineProps(uploadImgSingleProps);
  const emit = defineEmits(['update:value', 'change']);
  const { createMessage } = useMessage();
  const { t } = useI18n();
  const globSetting = useGlobSetting();
  const fileList = ref([]);
  const imageUrl = ref<string>('');
  const loading = ref<boolean>(false);
  const formItemContext = Form.useInjectFormItemContext();

  const getAction = computed(() => globSetting.uploadUrl + '/' + props.type);
  const getHeaders = computed(() => ({ Authorization: getToken() as string }));
  const getImgList = computed<string[]>(() => (imageUrl.value ? [getImageUrl(imageUrl.value)] : []));

  // 获取完整的图片URL（如果是相对路径，拼接baseURL）
  function getImageUrl(url: string): string {
    if (!url) return '';
    let fullUrl = '';

    // 如果已经是完整URL（包含http://或https://），直接使用
    if (url.startsWith('http://') || url.startsWith('https://')) {
      fullUrl = url;
    } else {
      // 如果是相对路径，拼接API基础URL
      const baseUrl = globSetting.apiUrl || '';
      if (url.startsWith('/')) {
        fullUrl = baseUrl + url;
      } else {
        fullUrl = baseUrl + '/' + url;
      }
    }

    // 对URL进行编码处理，确保中文字符正确编码
    try {
      // 解析URL，分别处理协议、域名和路径部分
      const urlObj = new URL(fullUrl);
      // 只编码路径部分，保留协议、域名、端口等
      const encodedPath = urlObj.pathname
        .split('/')
        .map(segment => encodeURIComponent(segment))
        .join('/');

      // 添加token参数，用于图片访问时的身份验证
      const token = getToken();
      const separator = urlObj.search ? '&' : '?';
      const tokenParam = token ? `${separator}token=${encodeURIComponent(token as string)}` : '';

      // 重新构建URL
      return urlObj.origin + encodedPath + (urlObj.search || '') + tokenParam + (urlObj.hash || '');
    } catch (e) {
      // 如果URL解析失败，使用encodeURI进行整体编码
      const token = getToken();
      const separator = fullUrl.includes('?') ? '&' : '?';
      const tokenParam = token ? `${separator}token=${encodeURIComponent(token as string)}` : '';
      return encodeURI(fullUrl) + tokenParam;
    }
  }

  watch(
    () => props.value,
    val => {
      imageUrl.value = val;
    },
    { immediate: true },
  );

  function beforeUpload(file: UploadFile) {
    const isAccept = file.type ? new RegExp('image/*').test(file.type) : false;
    if (!isAccept) {
      createMessage.error(t('component.upload.uploadImg'));
      return isAccept;
    }
    if (!props.fileSize) return true;
    const unitNum = units[props.sizeUnit];
    const isRightSize = file.size ? file.size / unitNum < props.fileSize : true;
    if (!isRightSize) {
      createMessage.error(`图片大小超过${props.fileSize}${props.sizeUnit}`);
      return false;
    }
    loading.value = true;
    return true;
  }

  function handleChange({ file }: UploadChangeParam) {
    if (file.status === 'uploading') return (loading.value = true);
    if (file.status === 'error') {
      loading.value = false;
      createMessage.error(t('component.upload.uploadError'));
      return;
    }
    if (file.status === 'done') {
      loading.value = false;
      if (file.response.code === 200) {
        const url = file.response.data.url;
        imageUrl.value = url;
        emit('update:value', unref(imageUrl));
        emit('change', unref(imageUrl));
        formItemContext.onFieldChange();
      } else {
        createMessage.error(file.response.msg);
      }
    }
  }
  function handlePreview() {
    createImgPreview({ imageList: unref(getImgList) });
  }
  function handleRemove() {
    imageUrl.value = '';
    emit('update:value', '');
    emit('change', '');
    formItemContext.onFieldChange();
  }
</script>
<style lang="less" scoped>
  .single-img-container {
    width: 100px;
    height: 100px;
    .ant-upload-list {
      .ant-upload-list-picture-card-container {
        width: 100px;
        height: 100px;
        margin: 0;
        .ant-upload-list-item {
          border-radius: var(--border-radius);
          position: relative;
          height: 100%;
          padding: 0;
          overflow: hidden;
          &:hover {
            .ant-upload-list-item-info:before {
              opacity: 1;
            }
          }
          .ant-upload-list-item-info {
            position: relative;
            height: 100%;
            overflow: hidden;
            &::before {
              position: absolute;
              z-index: 1;
              width: 100%;
              height: 100%;
              background-color: rgba(0, 0, 0, 0.45);
              opacity: 0;
              transition: all 0.3s;
              content: ' ';
            }
            .ant-upload-list-item-thumbnail {
              height: 100%;
              .ant-upload-list-item-image {
                height: 100%;
                width: 100%;
                object-fit: unset;
              }
            }
          }
          .ant-upload-list-item-actions {
            position: absolute;
            top: 50%;
            left: 50%;
            z-index: 10;
            white-space: nowrap;
            transform: translate(-50%, -50%);
            opacity: 0;
            transition: all 0.3s;
            &:hover {
              opacity: 1;
            }
            .anticon-eye,
            .anticon-delete {
              color: rgba(255, 255, 255, 0.85);
              font-size: 20px;
              margin: 0 10px;
            }
          }
        }
      }
    }
    .img-uploader {
      :deep(.ant-upload) {
        width: 100px;
        height: 100px;
        .anticon {
          font-size: 26px;
          color: #8c939d;
        }
        .ant-upload-text {
          margin-top: 10px;
          color: #8c939d;
          line-height: 18px;
          &.ant-upload-sub-text {
            margin-top: 0;
            font-size: 12px;
          }
        }
      }
    }
  }
</style>
