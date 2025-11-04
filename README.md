# XL Admin Template

一个前后端分离的企业级后台管理系统模板项目，基于 Spring Boot 3 + Vue 3 构建，开箱即用，可快速搭建自己的管理系统。

## ✨ 特性

### 🎯 核心功能
- ✅ 用户管理、角色管理、菜单管理
- ✅ RBAC 权限控制（基于 Sa-Token）
- ✅ 系统配置管理
- ✅ 完整的后台管理界面
- ✅ RESTful API 设计

### 🛠 技术栈

#### 后端技术栈
- **框架**: Spring Boot 3.1.5
- **语言**: Java 21
- **认证**: Sa-Token 1.37.0
- **ORM**: MyBatis Plus 3.5.3.1
- **数据库**: MySQL 8.0 / MongoDB
- **缓存**: Redis
- **工具库**: Hutool 5.8.22
- **构建工具**: Maven

#### 前端技术栈
- **框架**: Vue 3.4.27
- **UI组件**: Ant Design Vue 4.2.3
- **状态管理**: Pinia 2.1.3
- **路由**: Vue Router 4.3.2
- **构建工具**: Vite 4.5.3
- **语言**: TypeScript 5.4.5

## 📁 项目结构

```
xl-admin-template/
├── xl-im-backend/          # 后端项目
│   ├── xl-im-common/       # 通用模块
│   ├── xl-im-system/       # 系统模块（业务逻辑）
│   └── xl-im-admin/        # 管理模块（控制器、启动类）
└── xl-web/                  # 前端项目
    ├── src/
    │   ├── api/            # API 接口
    │   ├── components/     # 公共组件
    │   ├── views/          # 页面视图
    │   ├── store/          # 状态管理
    │   └── utils/          # 工具函数
    └── public/             # 静态资源
```

## 🚀 快速开始

### 环境要求

- JDK 21+
- Maven 3.6+
- Node.js 16.15+
- pnpm 8.1+
- MySQL 8.0+
- Redis

### 安装步骤

#### 1. 克隆项目

```bash
git clone <your-repository-url>
cd xl-admin-template













































```

#### 2. 后端启动

```bash
# 进入后端目录
cd xl-im-backend

# 配置数据库
# 修改 xl-im-admin/src/main/resources/application.yml 中的数据库连接信息

# 编译打包
mvn clean package

# 运行
cd xl-im-admin
java -jar target/xl-im-admin-1.0.0.jar

# 或者使用 Maven 运行
mvn spring-boot:run
```

后端服务默认运行在 `http://localhost:20250`

#### 3. 前端启动

```bash
# 进入前端目录
cd xl-web

# 安装依赖
pnpm install

# 启动开发服务器
pnpm dev

# 构建生产版本
pnpm build
```

前端服务默认运行在 `http://localhost:5173`

### 配置说明

#### 后端配置
编辑 `xl-im-admin/src/main/resources/application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/xl_im?useUnicode=true&characterEncoding=UTF-8
    username: root
    password: your_password
  
  data:
    redis:
      host: localhost
      port: 6379
      password: 
      database: 0
```

#### 前端配置
编辑 `xl-web/build/config/vite/proxy.ts` 配置代理：

```typescript
export default {
  '/api': {
    target: 'http://localhost:20250',
    changeOrigin: true,
  },
}
```

## 📖 使用指南

### 默认账号

```
用户名: admin
密码: 待创建（首次启动需要初始化）
```

### 功能模块

1. **用户管理**: 用户增删改查、角色分配
2. **角色管理**: 角色权限配置
3. **菜单管理**: 动态菜单、按钮权限
4. **系统配置**: 系统参数配置
5. **权限管理**: RBAC 权限控制

## 🔧 二次开发指南

### 添加新的业务模块

#### 后端

1. 在 `xl-im-system` 模块中创建实体类、Mapper、Service
2. 在 `xl-im-admin` 模块中创建 Controller
3. 添加相应的 Service 接口到 `xl-im-admin/src/main/resources/com/xl/admin/XlImApplication.java`

#### 前端

1. 在 `src/api` 目录创建 API 文件
2. 在 `src/views` 目录创建页面组件
3. 在路由配置中添加菜单路由

### 自定义配置

- **修改项目名称**: 更新 `pom.xml` 和 `package.json` 中的 name 字段
- **修改端口**: 修改 `application.yml` 中的 `server.port`
- **修改主题**: 在 `xl-web/src/design` 中配置主题色

## 📝 开发规范

### 代码规范
- 后端遵循阿里巴巴 Java 开发规范
- 前端遵循 Vue 3 + TypeScript 规范
- 使用 ESLint + Prettier 格式化代码

### Git 提交规范
```bash
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 重构
test: 测试相关
chore: 构建/工具链相关
```

## 🐛 问题反馈

如遇到问题，请在 Issues 中反馈。

## 📄 许可证

本项目基于 **Apache License 2.0** 许可证开源。

### 📋 许可证说明

⚠️ **重要提示**: 
- ✅ 允许学习、研究、使用、**商用**
- ✅ 允许修改和分发
- ✅ 允许闭源二次开发
- ✅ **必须保留原作者版权声明**
- ✅ 提供专利授权保护
- 📝 使用本项目需在文件头部保留版权信息和许可证声明

详细了解：[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)

## 🙏 致谢

感谢以下开源项目：
- [Spring Boot](https://spring.io/projects/spring-boot)
- [Vue 3](https://vuejs.org/)
- [Ant Design Vue](https://antdv.com/)
- [Sa-Token](https://sa-token.cc/)
- [MyBatis Plus](https://baomidou.com/)

## 📞 联系方式

如有合作意向或技术支持需求，欢迎联系。

---

**Star ⭐ 本项目，让更多人发现这个优秀的模板！**

