<template>
  <div class="single-img-container">
    <div class="ant-upload-list ant-upload-list-picture-card" v-if="imageUrl">
      <div class="ant-upload-list-picture-card-container">
        <div class="ant-upload-list-item ant-upload-list-item-done ant-upload-list-item-list-type-picture-card">
          <div class="ant-upload-list-item-info">
            <a class="ant-upload-list-item-thumbnail">
              <img :src=" imageUrl" class="ant-upload-list-item-image" />
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
        <loading-outlined v-if="loading"></loading-outlined>
        <plus-outlined v-else></plus-outlined>
        <div class="ant-upload-text" v-if="tipText">{{ tipText }}</div>
        <div class="ant-upload-text ant-upload-sub-text" v-if="subTipText">{{ subTipText }}</div>
      </div>
    </a-upload>
  </div>
</template>

<script lang="ts" setup>
  import { Form, Upload as AUpload } from 'ant-design-vue';
  import { PlusOutlined, LoadingOutlined, EyeOutlined, DeleteOutlined } from '@ant-design/icons-vue';
  import type { UploadChangeParam } from 'ant-design-vue';
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
  const apiUrl = ref(globSetting.apiUrl);
  const formItemContext = Form.useInjectFormItemContext();

  const getAction = computed(() => globSetting.uploadUrl + '/' + props.type);
  const getHeaders = computed(() => ({ Authorization: getToken() as string }));
  const getImgList = computed<string[]>(() => (imageUrl.value ? [imageUrl.value] : []));

  watch(
    () => props.value,
    val => {
      imageUrl.value = val;
    },
    { immediate: true },
  );

  function beforeUpload(file) {
    const isAccept = new RegExp('image/*').test(file.type);
    if (!isAccept) {
      createMessage.error(t('component.upload.uploadImg'));
      return isAccept;
    }
    if (!props.fileSize) return true;
    const unitNum = units[props.sizeUnit];
    const isRightSize = file.size / unitNum < props.fileSize;
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
        imageUrl.value = file.response.data.url;
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
