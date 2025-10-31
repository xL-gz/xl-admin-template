<template>
  <div class="youyi-content-wrapper">
    <div class="youyi-content-wrapper-center">
      <div class="youyi-content-wrapper-content">
        <!-- 三层架构说明提示 -->
        <a-alert 
          type="info" 
          show-icon 
          closable
          class="mb-4"
          message="三层架构权限管理"
          description="本系统采用三层架构：应用系统 → 菜单 → 权限。您可以为每个应用系统配置独立的菜单和权限体系。点击「菜单管理」进入第二层配置。">
          <template #icon>
            <i class="icon-ym icon-ym-generator-info" />
          </template>
        </a-alert>

        <BasicTable @register="registerTable">
          <template #tableTitle>
            <a-button type="primary" preIcon="icon-ym icon-ym-btn-add" @click="addOrUpdateHandle()">
              {{ t('common.addText') }}
            </a-button>
            <a-tooltip title="查看三层架构使用指南">
              <a-button preIcon="icon-ym icon-ym-generator-help" @click="showGuide">
                使用指南
              </a-button>
            </a-tooltip>
          </template>
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'icon'">
              <i :class="record.icon + ' table-icon'" />
            </template>
            <template v-if="column.key === 'enabledMark'">
              <a-tag :color="record.enabledMark == 1 ? 'success' : 'error'">{{ record.enabledMark == 1 ? '启用' : '禁用' }}</a-tag>
            </template>
            <template v-if="column.key === 'isMain'">
              <a-tag :color="record.isMain == 1 ? 'processing' : 'default'">
                {{ record.isMain == 1 ? '主系统' : '子系统' }}
              </a-tag>
            </template>
            <template v-if="column.key === 'action'">
              <TableAction :actions="getTableActions(record)" :dropDownActions="getDropDownActions(record)" />
            </template>
          </template>
        </BasicTable>
      </div>
    </div>
    <Form @register="registerForm" @reload="reload" />
    <Menu @register="registerMenu" />
    <Portal @register="registerPortal" />
    
    <!-- 使用指南弹窗 -->
    <BasicModal 
      v-model:open="guideVisible" 
      title="三层架构权限使用指南" 
      width="900px"
      :footer="null">
      <div class="guide-content">
        <a-typography-title :level="4">📋 架构说明</a-typography-title>
        <a-typography-paragraph>
          <a-steps direction="vertical" :current="0" size="small">
            <a-step title="第一层：应用系统" description="划分不同的业务领域，如：业务平台、开发平台等" />
            <a-step title="第二层：菜单管理" description="每个应用系统下配置独立的菜单树，支持9种菜单类型" />
            <a-step title="第三层：权限配置" description="为每个菜单配置按钮、列表、表单、数据四种权限" />
          </a-steps>
        </a-typography-paragraph>

        <a-divider />

        <a-typography-title :level="4">🎯 操作流程</a-typography-title>
        <a-typography-paragraph>
          <ol>
            <li>在此页面创建和管理应用系统</li>
            <li>点击应用系统的「<strong>菜单管理</strong>」按钮，进入该系统的菜单配置</li>
            <li>在菜单管理中，点击菜单的下拉操作，可配置该菜单的详细权限</li>
            <li>在角色管理中，为角色分配应用系统、菜单和权限</li>
          </ol>
        </a-typography-paragraph>

        <a-divider />

        <a-typography-title :level="4">✅ 权限类型</a-typography-title>
        <a-descriptions bordered size="small" :column="1">
          <a-descriptions-item label="按钮权限（Button）">
            控制页面上的操作按钮，如：新增、编辑、删除、导出等
          </a-descriptions-item>
          <a-descriptions-item label="列表权限（Column）">
            控制表格显示的列，可以隐藏敏感列
          </a-descriptions-item>
          <a-descriptions-item label="表单权限（Form）">
            控制表单字段的显示和编辑，可以隐藏或只读敏感字段
          </a-descriptions-item>
          <a-descriptions-item label="数据权限（Data）">
            控制数据范围，如：本部门数据、个人数据等
          </a-descriptions-item>
        </a-descriptions>

        <a-divider />

        <a-typography-paragraph>
          <a-space>
            <a-button type="link" href="/yy-web/三层架构权限使用指南.md" target="_blank">
              查看完整文档
            </a-button>
          </a-space>
        </a-typography-paragraph>
      </div>
    </BasicModal>
  </div>
</template>
<script lang="ts" setup>
  import { ref } from 'vue';
  import { BasicTable, useTable, TableAction, BasicColumn, ActionItem } from '@/components/Table';
  import { BasicModal } from '@/components/Modal';
  import { getSystemList, delSystem } from '@/api/system/system';
  import { useModal } from '@/components/Modal';
  import { useI18n } from '@/hooks/web/useI18n';
  import { useMessage } from '@/hooks/web/useMessage';
  import { usePopup } from '@/components/Popup';
  import Form from './Form.vue';
  import Menu from './components/menu/index.vue';
  import Portal from './components/portal/index.vue';

  defineOptions({ name: 'system-menu' });

  const { t } = useI18n();
  const { createMessage } = useMessage();
  const guideVisible = ref(false);
  
  const columns: BasicColumn[] = [
    { title: '应用名称', dataIndex: 'fullName', width: 200 },
    { title: '应用编码', dataIndex: 'enCode', width: 200 },
    { title: '说明', dataIndex: 'description' },
    { title: '类型', dataIndex: 'isMain', width: 80, align: 'center' },
    { title: '图标', dataIndex: 'icon', width: 50, align: 'center' },
    { title: '排序', dataIndex: 'sortCode', width: 70, align: 'center' },
    { title: '状态', dataIndex: 'enabledMark', width: 70, align: 'center' },
  ];
  const [registerForm, { openModal: openFormModal }] = useModal();
  const [registerMenu, { openPopup: openMenuPopup }] = usePopup();
  const [registerPortal, { openPopup: openPortalPopup }] = usePopup();
  const [registerTable, { reload }] = useTable({
    api: getSystemList,
    columns,
    useSearchForm: true,
    pagination: false,
    formConfig: {
      schemas: [
        {
          field: 'keyword',
          label: t('common.keyword'),
          component: 'Input',
          componentProps: {
            placeholder: t('common.enterKeyword'),
            submitOnPressEnter: true,
          },
        },
        {
          field: 'enabledMark',
          label: '状态',
          component: 'Select',
          componentProps: {
            placeholder: '请选择',
            options: [
              { fullName: '启用', id: 1 },
              { fullName: '禁用', id: 0 },
            ],
          },
        },
      ],
    },
    actionColumn: {
      width: 150,
      title: '操作',
      dataIndex: 'action',
    },
  });

  function getTableActions(record): ActionItem[] {
    return [
      {
        label: '菜单管理',  // 把菜单管理放到主要操作按钮中
        onClick: handleMenu.bind(null, record),
        color: 'success',
      },
      {
        label: t('common.editText'),
        onClick: addOrUpdateHandle.bind(null, record.id),
      },
    ];
  }
  function getDropDownActions(record): ActionItem[] {
    return [
      {
        label: t('common.delText'),
        color: 'error',
        disabled: record.isMain == 1,
        popConfirm: {  // 使用 popConfirm 而不是 modelConfirm
          title: '确定删除该应用系统吗？',
          confirm: handleDelete.bind(null, record.id),
        },
      },
      {
        ifShow: !record.isMain,  // 只有非主系统才显示门户管理
        label: '门户管理',
        onClick: handlePortal.bind(null, record),
      },
    ];
  }
  function addOrUpdateHandle(id = '') {
    openFormModal(true, { id });
  }
  function handleMenu(record) {
    openMenuPopup(true, { id: record.id, title: record.fullName, isDevPlatform: !!record.isMain });  // 修复：使用 isMain
  }
  function handlePortal(record) {
    openPortalPopup(true, { id: record.id, title: record.fullName });
  }
  function handleDelete(id) {
    delSystem(id).then(res => {
      createMessage.success(res.msg || res.message || '删除成功');
      reload();
    }).catch((error) => {
      // axios 拦截器已经处理了错误提示（在 transformResponseHook 中），这里只做错误捕获
      // 避免重复显示错误提示
      console.error('删除失败:', error);
    });
  }
  function showGuide() {
    guideVisible.value = true;
  }
</script>

<style scoped>
.guide-content {
  padding: 20px;
}
.guide-content ol {
  padding-left: 20px;
}
.guide-content ol li {
  margin-bottom: 8px;
  line-height: 1.8;
}
</style>
