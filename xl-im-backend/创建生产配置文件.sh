#!/bin/bash
# 在服务器上创建 application-prod.yml 配置文件

cat > /www/wwwroot/xl-im/application-prod.yml << 'EOF'
# 生产环境配置
server:
  port: 20250

spring:
  application:
    name: xl-im
  profiles:
    active: prod
  
  # MySQL数据库配置（修改为你的实际配置）
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/xl_im?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
    username: root  # 修改为你的MySQL用户名
    password: 你的MySQL密码  # ⚠️ 必须修改为你的MySQL密码
    
  # Redis配置
  data:
    redis:
      host: localhost
      port: 6379
      password:   # 如果Redis有密码，填写密码
      database: 0
      timeout: 3000ms
      lettuce:
        pool:
          max-active: 8
          max-wait: -1ms
          min-idle: 0
          max-idle: 8
    # MongoDB配置
    mongodb:
      uri: mongodb://localhost:27017/xl_im
      database: xl_im

# MyBatis Plus配置
mybatis-plus:
  configuration:
    map-underscore-to-camel-case: true
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
  global-config:
    db-config:
      logic-delete-field: deleted
      logic-delete-value: 1
      logic-not-delete-value: 0

# Sa-Token配置
sa-token:
  token-name: Authorization
  timeout: 2592000
  active-timeout: -1
  is-concurrent: true
  is-share: true
  token-style: uuid
  is-log: false

# 文件上传配置
file:
  upload:
    path: /www/wwwroot/uploads  # 上传文件存储路径
    base-url: http://159.75.243.81/uploads
    max-size: 10485760  # 10MB

# 日志配置（使用logback-spring.xml配置）
logging:
  level:
    com.xl: info
    org.springframework.web: warn
  config: classpath:logback-spring.xml
EOF

echo "✅ 配置文件已创建: /www/wwwroot/xl-im/application-prod.yml"
echo "⚠️  请记得修改MySQL密码！"

