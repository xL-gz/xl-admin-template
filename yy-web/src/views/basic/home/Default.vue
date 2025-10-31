<template>
  <div class="home-default-v">
    <div class="welcome-card enter-y">
      <a-card :bordered="false">
        <div class="welcome-content">
          <div class="welcome-icon">
            <icon icon="icon-ym icon-ym-nav-workbench" :size="60" />
          </div>
          <h1 class="welcome-title">欢迎使用 XL-IM 管理系统</h1>
          <p class="welcome-subtitle">企业级即时通讯管理平台</p>
          <a-divider />
          <div class="welcome-info">
            <a-row :gutter="16">
              <a-col :span="8">
                <a-statistic title="系统版本" value="1.0.0" />
              </a-col>
              <a-col :span="8">
                <a-statistic title="在线用户" :value="mockData.onlineUsers" suffix="人" />
              </a-col>
              <a-col :span="8">
                <a-statistic title="今日访问" :value="mockData.todayVisits" />
              </a-col>
            </a-row>
          </div>
        </div>
      </a-card>
    </div>

    <div class="stats-cards enter-y">
      <a-row :gutter="16">
        <a-col :span="6" v-for="item in statsData" :key="item.title">
          <a-card :bordered="false" :hoverable="true">
            <div class="stat-card">
              <div class="stat-icon" :style="{ background: item.color }">
                <icon :icon="item.icon" :size="24" color="#fff" />
              </div>
              <div class="stat-content">
                <p class="stat-title">{{ item.title }}</p>
                <h2 class="stat-value">{{ item.value }}</h2>
                <p class="stat-desc">{{ item.desc }}</p>
              </div>
            </div>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <div class="quick-links enter-y">
      <a-card title="快速入口" :bordered="false">
        <a-row :gutter="[16, 16]">
          <a-col :span="6" v-for="link in quickLinks" :key="link.title">
            <div class="quick-link-item" @click="handleQuickLink(link.path)">
              <icon :icon="link.icon" :size="32" />
              <p class="link-title">{{ link.title }}</p>
            </div>
          </a-col>
        </a-row>
      </a-card>
    </div>

    <p class="copyright enter-y">Copyright © 2024 XL Tech. All rights reserved.</p>
  </div>
</template>

<script lang="ts" setup>
  import { reactive } from 'vue';
  import { useRouter } from 'vue-router';
  import Icon from '@/components/Icon/src/Icon.vue';

  const router = useRouter();

  // 模拟数据
  const mockData = reactive({
    onlineUsers: 128,
    todayVisits: 1580,
  });

  // 统计数据
  const statsData = reactive([
    {
      title: '用户总数',
      value: '2,580',
      desc: '较昨日 +12%',
      icon: 'icon-ym icon-ym-generator-user',
      color: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    },
    {
      title: '消息总数',
      value: '58,260',
      desc: '较昨日 +5%',
      icon: 'icon-ym icon-ym-generator-message',
      color: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
    },
    {
      title: '群组数量',
      value: '458',
      desc: '较昨日 +3%',
      icon: 'icon-ym icon-ym-generator-createTable',
      color: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
    },
    {
      title: '活跃用户',
      value: '1,280',
      desc: '较昨日 +8%',
      icon: 'icon-ym icon-ym-generator-user',
      color: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)',
    },
  ]);

  // 快速链接
  const quickLinks = reactive([
    {
      title: '用户管理',
      icon: 'icon-ym icon-ym-generator-user',
      path: '/system/permission/user',
    },
    {
      title: '角色管理',
      icon: 'icon-ym icon-ym-generator-role',
      path: '/system/permission/role',
    },
    {
      title: '菜单管理',
      icon: 'icon-ym icon-ym-generator-menu',
      path: '/system/system/menu',
    },
    {
      title: '系统配置',
      icon: 'icon-ym icon-ym-generator-setup',
      path: '/system/system/sysConfig',
    },
  ]);

  function handleQuickLink(path: string) {
    router.push(path);
  }
</script>

<style lang="less" scoped>
  .home-default-v {
    padding: 16px;

    .ant-card {
      border-radius: 10px;
      overflow: hidden;
      margin-bottom: 16px;
    }

    .welcome-card {
      .welcome-content {
        text-align: center;
        padding: 40px 20px;

        .welcome-icon {
          margin-bottom: 20px;
          color: #1890ff;
        }

        .welcome-title {
          font-size: 32px;
          font-weight: 600;
          color: #333;
          margin-bottom: 10px;
        }

        .welcome-subtitle {
          font-size: 16px;
          color: #666;
          margin-bottom: 30px;
        }

        .welcome-info {
          margin-top: 30px;
          
          :deep(.ant-statistic-title) {
            font-size: 14px;
            color: #999;
          }

          :deep(.ant-statistic-content) {
            font-size: 24px;
            font-weight: 600;
            color: #1890ff;
          }
        }
      }
    }

    .stats-cards {
      .stat-card {
        display: flex;
        align-items: center;
        padding: 10px 0;

        .stat-icon {
          width: 60px;
          height: 60px;
          border-radius: 10px;
          display: flex;
          align-items: center;
          justify-content: center;
          margin-right: 16px;
          flex-shrink: 0;
        }

        .stat-content {
          flex: 1;

          .stat-title {
            font-size: 14px;
            color: #999;
            margin-bottom: 8px;
          }

          .stat-value {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 4px;
          }

          .stat-desc {
            font-size: 12px;
            color: #52c41a;
            margin: 0;
          }
        }
      }
    }

    .quick-links {
      .quick-link-item {
        text-align: center;
        padding: 24px;
        border: 1px solid #f0f0f0;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s;

        &:hover {
          border-color: #1890ff;
          transform: translateY(-4px);
          box-shadow: 0 4px 12px rgba(24, 144, 255, 0.2);
        }

        .link-title {
          margin-top: 12px;
          font-size: 14px;
          color: #666;
          margin-bottom: 0;
        }
      }
    }

    .copyright {
      font-size: 14px;
      text-align: center;
      padding: 20px 0 10px;
      color: #999;
      margin: 0;
    }
  }
</style>
