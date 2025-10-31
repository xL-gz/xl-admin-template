<template>
  <div class="youyi-content-wrapper">
    <div class="youyi-content-wrapper-center">
      <div class="youyi-content-wrapper-content">
        <!-- 权限演示说明 -->
        <a-alert 
          type="success" 
          show-icon 
          class="mb-4"
          message="三层架构权限演示页面"
          description="本页面演示如何在业务页面中使用三层架构的权限控制。您可以通过角色管理为不同角色配置不同的按钮、列表、表单权限。">
          <template #icon>
            <i class="icon-ym icon-ym-generator-info" />
          </template>
        </a-alert>

        <!-- 权限信息卡片 -->
        <a-row :gutter="16" class="mb-4">
          <a-col :span="6">
            <a-card size="small">
              <a-statistic
                title="当前菜单ID"
                :value="menuId"
                :value-style="{ color: '#3f8600' }">
                <template #prefix>
                  <i class="icon-ym icon-ym-generator-menu" />
                </template>
              </a-statistic>
            </a-card>
          </a-col>
          <a-col :span="6">
            <a-card size="small">
              <a-statistic
                title="按钮权限数"
                :value="buttonPermissions.length"
                :value-style="{ color: '#1890ff' }">
                <template #prefix>
                  <i class="icon-ym icon-ym-btn-add" />
                </template>
              </a-statistic>
            </a-card>
          </a-col>
          <a-col :span="6">
            <a-card size="small">
              <a-statistic
                title="列权限数"
                :value="columnPermissions.length"
                :value-style="{ color: '#722ed1' }">
                <template #prefix>
                  <i class="icon-ym icon-ym-generator-columnTable" />
                </template>
              </a-statistic>
            </a-card>
          </a-col>
          <a-col :span="6">
            <a-card size="small">
              <a-statistic
                title="表单权限数"
                :value="formPermissions.length"
                :value-style="{ color: '#eb2f96' }">
                <template #prefix>
                  <i class="icon-ym icon-ym-generator-form" />
                </template>
              </a-statistic>
            </a-card>
          </a-col>
        </a-row>

        <!-- 权限详情展示 -->
        <a-card title="当前用户权限详情" class="mb-4">
          <a-tabs>
            <a-tab-pane key="button" tab="按钮权限">
              <a-table 
                :columns="permissionColumns" 
                :dataSource="buttonPermissions" 
                :pagination="false"
                size="small">
                <template #bodyCell="{ column, record }">
                  <template v-if="column.key === 'status'">
                    <a-tag color="success">已授权</a-tag>
                  </template>
                </template>
              </a-table>
            </a-tab-pane>
            <a-tab-pane key="column" tab="列权限">
              <a-table 
                :columns="permissionColumns" 
                :dataSource="columnPermissions" 
                :pagination="false"
                size="small">
                <template #bodyCell="{ column, record }">
                  <template v-if="column.key === 'status'">
                    <a-tag color="success">已授权</a-tag>
                  </template>
                </template>
              </a-table>
            </a-tab-pane>
            <a-tab-pane key="form" tab="表单权限">
              <a-table 
                :columns="permissionColumns" 
                :dataSource="formPermissions" 
                :pagination="false"
                size="small">
                <template #bodyCell="{ column, record }">
                  <template v-if="column.key === 'status'">
                    <a-tag color="success">已授权</a-tag>
                  </template>
                </template>
              </a-table>
            </a-tab-pane>
          </a-tabs>
        </a-card>

        <!-- 按钮权限演示 -->
        <a-card title="按钮权限演示" class="mb-4">
          <a-space>
            <a-button 
              v-if="hasBtnAuth('add')" 
              type="primary"
              @click="handleAction('新增')">
              <template #icon><i class="icon-ym icon-ym-btn-add" /></template>
              新增（需要add权限）
            </a-button>
            <a-button 
              v-if="!hasBtnAuth('add')" 
              type="primary"
              disabled>
              <template #icon><i class="icon-ym icon-ym-btn-add" /></template>
              新增（无权限）
            </a-button>

            <a-button 
              v-if="hasBtnAuth('edit')"
              @click="handleAction('编辑')">
              <template #icon><i class="icon-ym icon-ym-btn-edit" /></template>
              编辑（需要edit权限）
            </a-button>
            <a-button 
              v-if="!hasBtnAuth('edit')"
              disabled>
              <template #icon><i class="icon-ym icon-ym-btn-edit" /></template>
              编辑（无权限）
            </a-button>

            <a-button 
              v-if="hasBtnAuth('delete')"
              danger
              @click="handleAction('删除')">
              <template #icon><i class="icon-ym icon-ym-btn-remove" /></template>
              删除（需要delete权限）
            </a-button>
            <a-button 
              v-if="!hasBtnAuth('delete')"
              danger
              disabled>
              <template #icon><i class="icon-ym icon-ym-btn-remove" /></template>
              删除（无权限）
            </a-button>

            <a-button 
              v-if="hasBtnAuth('export')"
              @click="handleAction('导出')">
              <template #icon><i class="icon-ym icon-ym-btn-output" /></template>
              导出（需要export权限）
            </a-button>
            <a-button 
              v-if="!hasBtnAuth('export')"
              disabled>
              <template #icon><i class="icon-ym icon-ym-btn-output" /></template>
              导出（无权限）
            </a-button>
          </a-space>

          <a-divider />

          <a-alert type="info" show-icon>
            <template #message>
              <strong>使用方式：</strong>
              <pre class="code-block">
&lt;a-button v-if="hasBtnAuth('add')" @click="handleAdd"&gt;新增&lt;/a-button&gt;
或
&lt;a-button v-auth="'add'" @click="handleAdd"&gt;新增&lt;/a-button&gt;</pre>
            </template>
          </a-alert>
        </a-card>

        <!-- 列权限演示 -->
        <a-card title="列权限演示（表格列根据权限动态显示）" class="mb-4">
          <BasicTable @register="registerTable" />
          
          <a-divider />

          <a-alert type="info" show-icon>
            <template #message>
              <strong>使用方式：</strong>
              <pre class="code-block">
const columns = computed(() => {
  return allColumns.filter(col => hasColumnAuth(menuId, col.enCode));
});</pre>
            </template>
          </a-alert>
        </a-card>

        <!-- 表单权限演示 -->
        <a-card title="表单权限演示（表单字段根据权限动态显示）">
          <BasicForm @register="registerForm" />
          
          <a-divider />

          <a-alert type="info" show-icon>
            <template #message>
              <strong>使用方式：</strong>
              <pre class="code-block">
const schemas = computed(() => {
  return allSchemas.filter(schema => hasFormAuth(menuId, schema.enCode));
});</pre>
            </template>
          </a-alert>
        </a-card>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import { BasicTable, useTable, BasicColumn } from '@/components/Table';
import { BasicForm, useForm, FormSchema } from '@/components/Form';
import { useUserStore } from '@/store/modules/user';
import { useMessage } from '@/hooks/web/useMessage';

defineOptions({ name: 'PermissionDemo' });

const route = useRoute();
const userStore = useUserStore();
const { createMessage } = useMessage();

// 模拟菜单ID（实际应从 route.meta.id 获取）
const menuId = 'demo-menu-001';

// 获取权限列表
const permissionList = computed(() => userStore.getPermissionList || []);

// 获取当前菜单的权限
const currentPermission = computed(() => {
  return permissionList.value.find(p => p.modelId === menuId) || {
    modelId: menuId,
    moduleName: '权限演示',
    button: [
      { id: 'btn_1', enCode: 'add', fullName: '新增' },
      { id: 'btn_2', enCode: 'edit', fullName: '编辑' },
      { id: 'btn_3', enCode: 'delete', fullName: '删除' },
    ],
    column: [
      { id: 'col_1', enCode: 'name', fullName: '名称' },
      { id: 'col_2', enCode: 'code', fullName: '编码' },
      { id: 'col_3', enCode: 'status', fullName: '状态' },
    ],
    form: [
      { id: 'form_1', enCode: 'name', fullName: '名称' },
      { id: 'form_2', enCode: 'code', fullName: '编码' },
      { id: 'form_3', enCode: 'description', fullName: '描述' },
    ],
    resource: [],
  };
});

// 按钮权限列表
const buttonPermissions = computed(() => currentPermission.value.button || []);

// 列权限列表
const columnPermissions = computed(() => currentPermission.value.column || []);

// 表单权限列表
const formPermissions = computed(() => currentPermission.value.form || []);

// 权限表格列定义
const permissionColumns = [
  { title: '权限ID', dataIndex: 'id', key: 'id' },
  { title: '权限编码', dataIndex: 'enCode', key: 'enCode' },
  { title: '权限名称', dataIndex: 'fullName', key: 'fullName' },
  { title: '状态', key: 'status', width: 100 },
];

// 检查按钮权限
function hasBtnAuth(buttonCode: string): boolean {
  return buttonPermissions.value.some(btn => btn.enCode === buttonCode);
}

// 检查列权限
function hasColumnAuth(columnCode: string): boolean {
  return columnPermissions.value.some(col => col.enCode === columnCode);
}

// 检查表单权限
function hasFormAuth(fieldCode: string): boolean {
  return formPermissions.value.some(field => field.enCode === fieldCode);
}

// ========== 表格配置 ==========
// 所有可能的列
const allColumns: BasicColumn[] = [
  { title: 'ID', dataIndex: 'id', width: 80, enCode: 'id' },
  { title: '名称', dataIndex: 'name', width: 150, enCode: 'name' },
  { title: '编码', dataIndex: 'code', width: 150, enCode: 'code' },
  { title: '状态', dataIndex: 'status', width: 100, enCode: 'status' },
  { title: '创建时间', dataIndex: 'createTime', width: 180, enCode: 'createTime' },
  { title: '备注', dataIndex: 'remark', enCode: 'remark' },
];

// 根据权限过滤列
const columns = computed(() => {
  return allColumns.filter(col => {
    // 如果没有设置 enCode，默认显示
    if (!col.enCode) return true;
    // 检查是否有该列的权限
    return hasColumnAuth(col.enCode);
  });
});

// 模拟数据
const mockData = [
  { id: 1, name: '演示数据1', code: 'DEMO001', status: '启用', createTime: '2024-01-01 10:00:00', remark: '这是一条演示数据' },
  { id: 2, name: '演示数据2', code: 'DEMO002', status: '禁用', createTime: '2024-01-02 11:00:00', remark: '这是另一条演示数据' },
  { id: 3, name: '演示数据3', code: 'DEMO003', status: '启用', createTime: '2024-01-03 12:00:00', remark: '第三条演示数据' },
];

const [registerTable] = useTable({
  dataSource: mockData,
  columns: columns.value,
  pagination: false,
  bordered: true,
});

// ========== 表单配置 ==========
// 所有可能的表单字段
const allSchemas: FormSchema[] = [
  {
    field: 'name',
    label: '名称',
    component: 'Input',
    enCode: 'name',
    required: true,
    componentProps: {
      placeholder: '请输入名称',
    },
  },
  {
    field: 'code',
    label: '编码',
    component: 'Input',
    enCode: 'code',
    required: true,
    componentProps: {
      placeholder: '请输入编码',
    },
  },
  {
    field: 'description',
    label: '描述',
    component: 'InputTextArea',
    enCode: 'description',
    componentProps: {
      placeholder: '请输入描述',
      rows: 4,
    },
  },
  {
    field: 'status',
    label: '状态',
    component: 'RadioGroup',
    enCode: 'status',
    defaultValue: 1,
    componentProps: {
      options: [
        { label: '启用', value: 1 },
        { label: '禁用', value: 0 },
      ],
    },
  },
  {
    field: 'remark',
    label: '备注',
    component: 'InputTextArea',
    enCode: 'remark',
    componentProps: {
      placeholder: '请输入备注',
      rows: 3,
    },
  },
];

// 根据权限过滤字段
const schemas = computed(() => {
  return allSchemas.filter(schema => {
    // 如果没有设置 enCode，默认显示
    if (!schema.enCode) return true;
    // 检查是否有该字段的权限
    return hasFormAuth(schema.enCode);
  });
});

const [registerForm] = useForm({
  labelWidth: 100,
  schemas: schemas.value,
  showActionButtonGroup: false,
  baseColProps: { span: 12 },
});

// ========== 业务逻辑 ==========
function handleAction(action: string) {
  createMessage.success(`执行${action}操作`);
}
</script>

<style scoped lang="less">
.code-block {
  margin-top: 8px;
  padding: 12px;
  background: #f6f7f9;
  border-radius: 4px;
  font-size: 13px;
  line-height: 1.6;
  overflow-x: auto;
}

:deep(.ant-statistic-title) {
  font-size: 14px;
}

:deep(.ant-statistic-content) {
  font-size: 20px;
}
</style>

