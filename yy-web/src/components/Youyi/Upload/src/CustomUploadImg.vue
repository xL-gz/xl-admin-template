<template>
  <div class="upload-img-container" :class="$attrs.class">
    <transition-group class="ant-upload-list ant-upload-list-picture-card" tag="div" name="list" v-if="!simple">
      <div class="ant-upload-list-picture-card-container" v-for="(url, index) in imgList" :key="index">
        <div class="ant-upload-list-item ant-upload-list-item-done ant-upload-list-item-list-type-picture-card">
          <div class="ant-upload-list-item-info">
            <a class="ant-upload-list-item-thumbnail">
              <img :src="url" class="ant-upload-list-item-image" />
            </a>
          </div>
          <span class="ant-upload-list-item-actions">
            <EyeOutlined @click="handlePreview(index)" />
            <DeleteOutlined @click="handleRemove(index)" v-if="!disabled && !detailed" />
          </span>
        </div>
      </div>
    </transition-group>
    
    <a-upload
      v-model:file-list="fileList"
      list-type="picture-card"
      class="img-uploader"
      :accept="accept"
      :disabled="disabled || detailed"
      :show-upload-list="false"
      :multiple="limit != 1"
      :max-count="limit === 0 ? undefined : limit"
      :action="getAction"
      :headers="getHeaders"
      :before-upload="beforeUpload"
      @change="handleChange"
      v-if="!detailed">
      <div>
        <plus-outlined></plus-outlined>
        <div class="ant-upload-text" v-if="buttonText">{{ buttonText }}</div>
      </div>
    </a-upload>
  </div>
</template>

<script lang="ts" setup>
import { computed, ref, unref, watch } from 'vue';
import { Form } from 'ant-design-vue';
import { PlusOutlined, EyeOutlined, DeleteOutlined } from '@ant-design/icons-vue';
import { useGlobSetting } from '@/hooks/setting';
import { getToken } from '@/utils/auth';
import { useMessage } from '@/hooks/web/useMessage';
import { useI18n } from '@/hooks/web/useI18n';
import { createImgPreview } from '@/components/Preview';

const props = defineProps({
  value: { type: Array, default: () => [] },
  disabled: { type: Boolean, default: false },
  detailed: { type: Boolean, default: false },
  limit: { type: Number, default: 0 },
  accept: { type: String, default: '.jpg,.jpeg,.png,.gif' },
  buttonText: { type: String, default: '' },
  simple: { type: Boolean, default: false }
});

const emit = defineEmits(['update:value', 'change']);
const { createMessage } = useMessage();
const { t } = useI18n();
const globSetting = useGlobSetting();
const fileList = ref([]);
const imgList = ref<string[]>([]);

const getAction = computed(() => globSetting.uploadUrl + '/Annex');
const getHeaders = computed(() => ({ Authorization: getToken() as string }));

watch(() => props.value, (val) => {
  imgList.value = val || [];
}, { deep: true, immediate: true });

function beforeUpload(file) {
  const isAccept = new RegExp('image/*').test(file.type);
  if (!isAccept) {
    createMessage.error('请上传图片格式文件!');
    return false;
  }
  return true;
}

function handleChange({ file }) {
  if (file.status === 'done') {
    if (file.response.code === 200) {
      // 只保存 url
      const url = file.response.data.url;
      imgList.value.push(url);
      emit('update:value', unref(imgList));
      emit('change', unref(imgList));
    } else {
      createMessage.error(file.response.msg);
    }
  }
}

function handlePreview(index: number) {
  createImgPreview({ 
    imageList: imgList.value,
    index 
  });
}

function handleRemove(index: number) {
  imgList.value.splice(index, 1);
  emit('update:value', unref(imgList));
  emit('change', unref(imgList));
}
</script>

<style lang="less" scoped>
.upload-img-container {
  .ant-upload-list {
    display: inline;
    .ant-upload-list-picture-card-container {
      display: inline-block;
      width: 100px;
      height: 100px;
      margin: 0 8px 8px 0;
      vertical-align: top;
    }
  }
  .img-uploader {
    width: 100px;
    display: inline-block;
    vertical-align: top;
  }
}
</style> 
