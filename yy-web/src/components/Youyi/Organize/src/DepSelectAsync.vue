<template>
  <div :class="[$attrs.class, 'select-tag-list']" v-if="buttonType === 'button'">
    <a-button preIcon="icon-ym icon-ym-btn-add" @click="openSelectModal">{{ modalTitle }}</a-button>
    <div class="tags">
      <a-tag class="!mt-10px" :closable="!disabled" v-for="(item, i) in options" :key="item.id" @close="onTagClose(i)">{{ item.fullName }}</a-tag>
    </div>
  </div>
  <a-select v-bind="getSelectBindValue" v-model:value="innerValue" :options="options" @change="onChange" @click="openSelectModal" v-else />
  <a-modal v-model:open="visible" :title="modalTitle" :width="800" class="transfer-modal" @ok="handleSubmit" centered :maskClosable="false" :keyboard="false">
    <template #closeIcon>
      <ModalClose :canFullscreen="false" @cancel="handleCancel" />
    </template>
    <div class="transfer__body">
      <div class="transfer-pane left-pane">
        <div class="transfer-pane__tool">
          <a-input-search :placeholder="t('common.enterKeyword')" allowClear v-model:value="pagination.keyword" @search="handleSearch" />
        </div>
        <div class="transfer-pane__body transfer-pane__body-tab">
          <a-tabs v-model:activeKey="activeKey" :tabBarGutter="10" size="small" class="pane-tabs" v-if="hasSys">
            <a-tab-pane key="1" tab="全部数据"></a-tab-pane>
            <a-tab-pane key="system" tab="动态参数"></a-tab-pane>
          </a-tabs>
          <BasicTree class="tree-main" ref="treeRef" v-bind="getTreeBindValue" v-if="!isAsync" />
          <ScrollContainer v-loading="loading && pagination.currentPage === 1" v-else ref="infiniteBody">
            <div v-for="item in treeData" :key="item.id" class="selected-item" @click="handleNodeClick(item)">
              <span :title="item.fullName">{{ item.fullName }}</span>
            </div>
            <youyi-empty v-if="!treeData.length" />
          </ScrollContainer>
        </div>
      </div>
      <div class="transfer-pane right-pane">
        <div class="transfer-pane__tool">
          <span>已选</span>
          <span class="remove-all-btn" @click="removeAll">清空列表</span>
        </div>
        <div class="transfer-pane__body">
          <ScrollContainer>
            <div v-for="(item, i) in selectedData" :key="i" class="selected-item">
              <span :title="item.fullName">{{ item.fullName }}</span>
              <delete-outlined class="delete-btn" @click="removeData(i)" />
            </div>
            <youyi-empty v-if="!selectedData.length" />
          </ScrollContainer>
        </div>
      </div>
    </div>
  </a-modal>
</template>

<script lang="ts" setup>
  // import { getDepartmentSelectAsyncList, getOrgByOrganizeCondition, getSelectedList } from '@/api/permission/organize'; // 已删除 - 后端无此接口
  // 占位符函数
  const getDepartmentSelectAsyncList = () => Promise.resolve({ data: { list: [] } });
  const getOrgByOrganizeCondition = () => Promise.resolve({ data: { list: [] } });
  const getSelectedList = () => Promise.resolve({ data: { list: [] } });
  import { Form, Modal as AModal } from 'ant-design-vue';
  import { DeleteOutlined } from '@ant-design/icons-vue';
  import { computed, ref, unref, watch, nextTick, reactive } from 'vue';
  import { BasicTree, TreeActionType } from '@/components/Tree';
  import { ScrollContainer, ScrollActionType } from '@/components/Container';
  import { depSelectProps } from './props';
  import ModalClose from '@/components/Modal/src/components/ModalClose.vue';
  import { useI18n } from '@/hooks/web/useI18n';
  import { useAttrs } from '@/hooks/core/useAttrs';
  import { cloneDeep, pick } from 'lodash-es';

  defineOptions({ name: 'YouyiDepSelect', inheritAttrs: false });
  const props = defineProps(depSelectProps);
  const emit = defineEmits(['update:value', 'change', 'labelChange']);
  const attrs: any = useAttrs({ excludeDefaultKeys: false });
  const { t } = useI18n();
  const visible = ref(false);
  const treeRef = ref<Nullable<TreeActionType>>(null);
  const innerValue = ref<string | any[] | undefined>([]);
  const nodeId = ref('0');
  const treeKey = ref(+new Date());
  const pagination = reactive({
    keyword: '',
    currentPage: 1,
    pageSize: 20,
  });
  const finish = ref<boolean>(false);
  const isAsync = ref<boolean>(false);
  const activeKey = ref('');
  const infiniteBody = ref<Nullable<ScrollActionType>>(null);
  const treeData = ref<any[]>([]);
  const options = ref<any[]>([]);
  const loading = ref(false);
  const selectedData = ref<any[]>([]);
  const formItemContext = Form.useInjectFormItemContext();
  const systemFieldList = ref<any[]>([
    { id: '@currentOrg', fullName: '当前组织' },
    { id: '@currentOrgAndSubOrg', fullName: '当前组织及子组织' },
    { id: '@currentGradeOrg', fullName: '当前分管组织' },
  ]);

  const getSelectBindValue = computed(() => ({
    ...pick(props, ['placeholder', 'disabled', 'size', 'allowClear']),
    fieldNames: { label: 'fullName', value: 'id' },
    open: false,
    mode: props.multiple ? 'multiple' : '',
    showSearch: false,
    showArrow: true,
    class: unref(attrs).class ? 'w-full ' + unref(attrs).class : 'w-full',
  }));
  const getTreeBindValue = computed(() => {
    const data: any = {
      treeData: treeData.value,
      onSelect: handleSelect,
      defaultExpandAll: props.selectType !== 'all' || activeKey.value !== '1',
      loading: loading.value,
      key: treeKey.value,
    };
    if (props.selectType === 'all' && activeKey.value === '1') data.loadData = onLoadData;
    return data;
  });

  watch(
    () => props.value,
    () => {
      setValue();
    },
    { immediate: true },
  );
  watch(
    () => activeKey.value,
    val => {
      if (!val) return;
      if (val === 'system') return (treeData.value = cloneDeep(systemFieldList.value));
      if (props.selectType === 'all') {
        handleSearch('');
      } else {
        initData();
      }
    },
  );
  watch(
    () => visible.value,
    val => {
      if (!val) activeKey.value = '';
    },
  );

  function setValue() {
    if (!props.value || !props.value.length) return setNullValue();
    let ids = props.multiple ? (props.value as any[]) : [props.value];
    if (!Array.isArray(ids)) return;
    const selectSysData: any[] = getSelectSysData(ids);
    ids = ids.filter(o => o.indexOf('@') < 0);
    if (!ids.length) return setOptions(selectSysData);
    getSelectedList(ids).then(res => {
      if (!props.value || !props.value.length) return setNullValue();
      setOptions([...(res.data.list || []), ...selectSysData]);
    });
  }
  function setOptions(data) {
    if (!props.value || !props.value.length) return setNullValue();
    const selectedList: any[] = data;
    const innerIds = selectedList.map(o => o.id);
    innerValue.value = props.multiple ? innerIds : innerIds[0];
    options.value = cloneDeep(selectedList);
    selectedData.value = cloneDeep(selectedList);
    const labels = selectedData.value.map(o => o.fullName).join();
    emit('labelChange', labels);
  }
  function setNullValue() {
    innerValue.value = props.multiple ? [] : undefined;
    options.value = [];
    selectedData.value = [];
    emit('labelChange', '');
  }
  function getSelectSysData(ids) {
    let list: any[] = [];
    for (let i = 0; i < unref(systemFieldList).length; i++) {
      inner: for (let j = 0; j < ids.length; j++) {
        if (unref(systemFieldList)[i].id === ids[j]) {
          list.push({ ...unref(systemFieldList)[i] });
          break inner;
        }
      }
    }
    return list;
  }
  function onChange(_val, option) {
    selectedData.value = option ?? [];
    handleSubmit();
  }
  function onTagClose(i) {
    selectedData.value.splice(i, 1);
    handleSubmit();
  }
  function openSelectModal() {
    if (props.disabled) return;
    visible.value = true;
    isAsync.value = false;
    pagination.keyword = '';
    pagination.currentPage = 1;
    nodeId.value = '0';
    finish.value = false;
    activeKey.value = '1';
    treeData.value = [];
    setValue();
    nextTick(() => {
      bindScroll();
    });
  }
  function handleCancel() {
    visible.value = false;
  }
  function handleSearch(value) {
    if (loading.value) return;
    pagination.keyword = value || '';
    if (props.selectType !== 'all' || activeKey.value !== '1') return getTree().setSearchValue(value);
    treeKey.value = +new Date();
    nodeId.value = '0';
    treeData.value = [];
    pagination.currentPage = 1;
    isAsync.value = !!pagination.keyword;
    finish.value = false;
    if (isAsync.value) {
      nextTick(() => {
        bindScroll();
      });
    }
    initData();
  }
  function handleSelect(keys) {
    if (!keys.length) return;
    const data: any = getTree().getSelectedNode(keys[0]);
    if (data?.disabled || data?.type === 'company') return;
    handleNodeClick(data);
  }
  function handleNodeClick(data) {
    const boo = selectedData.value.some(o => o.id === data.id);
    if (boo) return;
    const item = cloneDeep(data);
    if (props.selectType === 'custom') item.fullName = item.lastFullName;
    props.multiple ? selectedData.value.push(item) : (selectedData.value = [item]);
  }
  function removeAll() {
    selectedData.value = [];
  }
  function removeData(index: number) {
    selectedData.value.splice(index, 1);
  }
  function getTree() {
    const tree = unref(treeRef);
    if (!tree) {
      throw new Error('tree is null!');
    }
    return tree;
  }
  function handleSubmit() {
    const ids = unref(selectedData).map(o => o.id);
    options.value = unref(selectedData);
    innerValue.value = props.multiple ? ids : ids[0];
    if (props.multiple) {
      emit('update:value', ids);
      emit('change', ids, unref(options));
    } else {
      emit('update:value', ids[0] || '');
      emit('change', ids[0] || '', unref(options)[0]);
    }
    formItemContext.onFieldChange();
    handleCancel();
  }
  function bindScroll() {
    const bodyRef = infiniteBody.value;
    const vBody = bodyRef?.getScrollWrap();
    vBody?.addEventListener('scroll', () => {
      if (vBody.scrollHeight - vBody.clientHeight - vBody.scrollTop <= 200 && !loading.value && !finish.value) {
        pagination.currentPage += 1;
        getList();
      }
    });
  }
  function onLoadData(node) {
    nodeId.value = node.id;
    return new Promise((resolve: (value?: unknown) => void) => {
      getDepartmentSelectAsyncList(nodeId.value, pagination).then(res => {
        const list = res.data.list;
        getTree().updateNodeByKey(node.eventKey, { children: list, isLeaf: !list.length });
        resolve();
      });
    });
  }
  function getList() {
    loading.value = true;
    if (pagination.keyword) nodeId.value = '0';
    getDepartmentSelectAsyncList(nodeId.value, pagination)
      .then(res => {
        if (pagination.keyword) {
          if (res.data.list.length < pagination.pageSize) finish.value = true;
          treeData.value = [...treeData.value, ...res.data.list];
        } else {
          treeData.value = res.data.list;
          if (treeData.value.length && nodeId.value == '0') {
            getTree().setExpandedKeys([treeData.value[0].id]);
          }
        }
        loading.value = false;
      })
      .catch(() => {
        loading.value = false;
      });
  }
  async function initData() {
    if (props.selectType === 'all') {
      if (activeKey.value === 'system') {
        treeData.value = cloneDeep(systemFieldList.value);
      } else {
        getList();
      }
    } else {
      if (!props.ableIds?.length) return (treeData.value = []);
      loading.value = true;
      const query = { departIds: props.ableIds };
      getOrgByOrganizeCondition(query).then(res => {
        treeData.value = res.data.list;
        loading.value = false;
      });
    }
  }
</script>
