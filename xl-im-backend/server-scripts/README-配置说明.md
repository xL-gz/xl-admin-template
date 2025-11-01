# 配置文件管理说明

## 🎯 推荐方案：使用环境变量

为了安全和管理方便，**推荐使用 `.env` 文件**来管理敏感配置（如数据库密码）。

---

## 快速开始

### 1. 创建环境变量文件

在服务器上执行：

```bash
cd /www/wwwroot/xl-im

# 创建 .env 文件
cat > .env << 'EOF'
# 数据库配置
DB_USERNAME=root
DB_PASSWORD=你的MySQL密码

# Redis配置（如果没有密码可以留空）
REDIS_PASSWORD=

# 其他配置使用默认值即可
EOF

# 设置文件权限（保护敏感信息）
chmod 600 .env
```

### 2. 启动服务

```bash
./start.sh
```

启动脚本会自动加载 `.env` 文件中的环境变量。

---

## 环境变量说明

| 变量名 | 说明 | 默认值 | 是否必填 |
|--------|------|--------|----------|
| `DB_URL` | MySQL连接URL | localhost:3306/xl_im | 否 |
| `DB_USERNAME` | MySQL用户名 | root | 否 |
| `DB_PASSWORD` | MySQL密码 | 空 | **是** |
| `REDIS_HOST` | Redis地址 | localhost | 否 |
| `REDIS_PORT` | Redis端口 | 6379 | 否 |
| `REDIS_PASSWORD` | Redis密码 | 空 | 否 |
| `MONGODB_URI` | MongoDB连接URI | mongodb://localhost:27017/xl_im | 否 |
| `UPLOAD_PATH` | 文件上传路径 | /www/wwwroot/uploads | 否 |
| `UPLOAD_BASE_URL` | 文件访问URL | http://159.75.243.81/uploads | 否 |

---

## 配置优先级

1. **环境变量**（.env文件或系统环境变量）- 最高优先级
2. **外部配置文件**（application-prod.yml）- 如果存在
3. **JAR包内配置**（application-prod.yml）- 默认值

---

## 安全提示

- ✅ `.env` 文件只包含敏感信息，不会被提交到Git
- ✅ 设置文件权限：`chmod 600 .env`
- ✅ 不同环境（开发/测试/生产）使用不同的密码

