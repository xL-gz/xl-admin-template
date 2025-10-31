<template>
  <div :class="[$attrs.class, 'select-tag-list']" v-if="buttonType === 'button'">
    <a-button preIcon="icon-ym icon-ym-btn-add" @click="openSelectModal">{{ modalTitle }}</a-button>
    <div class="tags">
      <a-tag class="!mt-10px" :closable="!disabled" v-for="(item, i) in options" :key="item.id" @close="onTagClose(i)">{{ item.organize }}</a-tag>
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
              <span :title="item.organize">{{ item.organize }}</span>
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
              <span :title="item.organize">{{ item.organize }}</span>
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
  // import {
  //   getOrganizeSelectorAsyncByAuth,
  //   getDepartmentSelectorAsyncByAuth,
  //   getOrgByOrganizeCondition,
  //   getDepartmentSelectAsyncList,
  //   getSelectedList,
  // } from '@/api/permission/organize'; // 已删除 - 后端无此接口
  // 占位符函数
  const getOrganizeSelectorAsyncByAuth = () => Promise.resolve({ data: { list: [] } });
  const getDepartmentSelectorAsyncByAuth = () => Promise.resolve({ data: { list: [] } });
  const getOrgByOrganizeCondition = () => Promise.resolve({ data: { list: [] } });
  const getDepartmentSelectAsyncList = () => Promise.resolve({ data: { list: [] } });
  const getSelectedList = () => Promise.resolve({ data: { list: [] } });
  import { Form, Modal as AModal } from 'ant-design-vue';
  import { DeleteOutlined } from '@ant-design/icons-vue';
  import { computed, ref, unref, watch, nextTick, reactive } from 'vue';
  import { BasicTree, TreeActionType } from '@/components/Tree';
  import { ScrollContainer, ScrollActionType } from '@/components/Container';
  import { organizeSelectProps } from './props';
  import ModalClose from '@/components/Modal/src/components/ModalClose.vue';
  import { useI18n } from '@/hooks/web/useI18n';
  import { useAttrs } from '@/hooks/core/useAttrs';
  import { cloneDeep, pick } from 'lodash-es';

  defineOptions({ name: 'YouyiOrganizeSelect', inheritAttrs: false });
  const props = defineProps(organizeSelectProps);
  const emit = defineEmits(['update:value', 'change']);
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
    currOrgId: '',
  });
  const finish = ref<boolean>(false);
  const isAsync = ref<boolean>(false);
  const activeKey = ref('');
  const infiniteBody = ref<Nullable<ScrollActionType>>(null);
  const treeData = ref<any[]>([]);
  const options = ref<any[]>([]);
  const loading = ref(false);
  const selectedIds = ref<any[]>([]);
  const selectedData = ref<any[]>([]);
  const formItemContext = Form.useInjectFormItemContext();
  const systemFieldList = ref<any[]>([
    { id: '@currentOrg', fullName: '当前组织', organizeIds: ['@currentOrg'], organize: '当前组织' },
    { id: '@currentOrgAndSubOrg', fullName: '当前组织及子组织', organizeIds: ['@currentOrgAndSubOrg'], organize: '当前组织及子组织' },
    { id: '@currentGradeOrg', fullName: '当前分管组织', organizeIds: ['@currentGradeOrg'], organize: '当前分管组织' },
  ]);
  const topItem = { id: '-1', fullName: '顶级节点', organize: '顶级节点', organizeIds: ['-1'], hasChildren: true, icon: 'icon-ym icon-ym-tree-organization3' };

  const getSelectBindValue = computed(() => ({
    ...pick(props, ['placeholder', 'disabled', 'size', 'allowClear']),
    fieldNames: { label: 'organize', value: 'id' },
    open: false,
    mode: props.multiple ? 'multiple' : '',
    showSearch: false,
    showArrow: true,
    class: unref(attrs).class ? 'w-full ' + unref(attrs).class : 'w-full',
  }));
  const getIsLazy = computed(() => props.selectType === 'all' && (!props.auth || (props.auth && props.parentId !== '-1')) && activeKey.value === '1');
  const getTreeBindValue = computed(() => {
    const data: any = {
      treeData: treeData.value,
      onSelect: handleSelect,
      defaultExpandAll: !unref(getIsLazy),
      loading: loading.value,
      key: treeKey.value,
    };
    if (unref(getIsLazy)) data.loadData = onLoadData;
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
      isAsync.value = false;
      pagination.keyword = '';
      initData();
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
    const ids = props.multiple ? (props.value as any[]) : [props.value];
    if (!Array.isArray(ids[0])) return;
    let lastIds = ids.map(o => o[o.length - 1]);
    const selectSysData: any[] = getSelectSysData(lastIds);
    lastIds = lastIds.filter(o => o.indexOf('@') < 0 && o !== '-1');
    if (!lastIds.length) return setOptions(selectSysData);
    getSelectedList(lastIds).then(res => {
      if (!props.value || !props.value.length) return setNullValue();
      setOptions([...(res.data.list || []), ...selectSysData]);
    });
  }
  function setOptions(data) {
    if (!props.value || !props.value.length) return setNullValue();
    const selectedList: any[] = data;
    selectedIds.value = selectedList.map(o => o.organizeIds);
    const innerIds = selectedList.map(o => o.id);
    innerValue.value = props.multiple ? innerIds : innerIds[0];
    options.value = cloneDeep(selectedList);
    selectedData.value = cloneDeep(selectedList);
  }
  function setNullValue() {
    innerValue.value = props.multiple ? [] : undefined;
    options.value = [];
    selectedIds.value = [];
    selectedData.value = [];
  }
  function getSelectSysData(ids) {
    let list: any[] = [];
    const sysFieldList = [...unref(systemFieldList), topItem];
    for (let i = 0; i < sysFieldList.length; i++) {
      inner: for (let j = 0; j < ids.length; j++) {
        if (sysFieldList[i].id === ids[j]) {
          list.push({ ...sysFieldList[i] });
          break inner;
        }
      }
    }
    return list;
  }
  function onChange(_val, option) {
    if (!option) {
      selectedData.value = [];
      selectedIds.value = [];
    } else {
      selectedData.value = option;
      selectedIds.value = option.map(o => o.organizeIds);
    }
    handleSubmit();
  }
  function onTagClose(i) {
    selectedIds.value.splice(i, 1);
    selectedData.value.splice(i, 1);
    handleSubmit();
  }
  function openSelectModal() {
    if (props.disabled) return;
    visible.value = true;
    activeKey.value = '1';
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
    if (!unref(getIsLazy)) return getTree().setSearchValue(value);
    isAsync.value = !!pagination.keyword;
    if (isAsync.value) {
      nextTick(() => {
        bindScroll();
      });
    }
    initData();
  }
  function handleSelect(keys) {
    if (!keys.length) return;
    const data = getTree().getSelectedNode(keys[0]);
    if (data?.disabled) return;
    handleNodeClick(data);
  }
  function handleNodeClick(data) {
    const currId = data?.organizeIds;
    if (props.multiple) {
      const boo = selectedIds.value.some(o => o.join() === currId.join());
      if (boo) return;
      selectedIds.value.push(currId);
      selectedData.value.push(data);
    } else {
      selectedIds.value = [currId];
      selectedData.value = [data];
    }
  }
  function removeAll() {
    selectedIds.value = [];
    selectedData.value = [];
  }
  function removeData(index: number) {
    selectedIds.value.splice(index, 1);
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
      emit('update:value', unref(selectedIds));
      emit('change', unref(selectedIds), unref(options));
    } else {
      emit('update:value', unref(selectedIds)[0] || '');
      emit('change', unref(selectedIds)[0] || '', unref(options)[0]);
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
      const method = !props.auth ? getDepartmentSelectAsyncList : props.isOnlyOrg ? getOrganizeSelectorAsyncByAuth : getDepartmentSelectorAsyncByAuth;
      method(nodeId.value, pagination).then(res => {
        const list = res.data.list;
        getTree().updateNodeByKey(node.eventKey, { children: list, isLeaf: !list.length });
        resolve();
      });
    });
  }
  function getList() {
    loading.value = true;
    if (pagination.keyword) nodeId.value = '0';
    const method = !props.auth ? getDepartmentSelectAsyncList : props.isOnlyOrg ? getOrganizeSelectorAsyncByAuth : getDepartmentSelectorAsyncByAuth;
    method(nodeId.value, pagination)
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
        treeData.value = [topItem,...treeData.value]
        loading.value = false;
      })
      .catch(() => {
        loading.value = false;
      });
  }
  async function initData() {
    treeKey.value = +new Date();
    nodeId.value = '0';
    finish.value = false;
    treeData.value = [];
    pagination.currentPage = 1;
    pagination.currOrgId = props.currOrgId || '';
    if (props.selectType === 'all') {
      if (props.auth) {
        if (props.isOnlyOrg && props.parentId === '-1') return (treeData.value = [topItem]);
        nodeId.value = '0';
        getList();
      } else {
        if (activeKey.value === '1') {
          getList();
        } else {
          treeData.value = cloneDeep(systemFieldList.value);
        }
      }
    } else {
      if (!props.ableIds?.length) return (treeData.value = []);
      loading.value = true;
      const departIds = props.ableIds ? props.ableIds.map(o => o[o.length - 1]) : [];
      const query = { departIds };
      getOrgByOrganizeCondition(query).then(res => {
        treeData.value = res.data.list;
        loading.value = false;
      });
    }
  }
</script>
