#!/bin/bash
# XL-IM 后端启动脚本（使用JAR包内配置）

APP_DIR="/www/wwwroot/xl-im"
APP_NAME="xl-im-admin"
JAR_FILE="${APP_DIR}/xl-im-admin-1.0.0.jar"
LOG_FILE="${APP_DIR}/logs/xl-im.log"
ERROR_LOG_FILE="${APP_DIR}/logs/xl-imerror.log"
PID_FILE="${APP_DIR}/xl-im.pid"

# 进入应用目录
cd ${APP_DIR}

# 创建日志目录
mkdir -p ${APP_DIR}/logs

# 检查Java是否安装
if ! command -v java &> /dev/null; then
    echo "❌ 错误：未找到Java，请先安装Java 21"
    exit 1
fi

# 检查JAR文件是否存在
if [ ! -f "$JAR_FILE" ]; then
    echo "❌ 错误：JAR文件不存在: $JAR_FILE"
    exit 1
fi

# 检查是否已经运行
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat $PID_FILE)
    if ps -p $OLD_PID > /dev/null 2>&1; then
        echo "⚠️  应用已经在运行中 (PID: $OLD_PID)"
        echo "   如需重启，请先执行: ./stop.sh"
        exit 1
    else
        # PID文件存在但进程不存在，删除旧PID文件
        rm -f $PID_FILE
    fi
fi

# 设置Java环境变量（根据实际路径调整）
export JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-21-openjdk}
export PATH=$JAVA_HOME/bin:$PATH

echo "=========================================="
echo "启动 XL-IM 后端服务..."
echo "=========================================="
echo "应用目录: $APP_DIR"
echo "JAR文件: $JAR_FILE"
echo "所有日志: $LOG_FILE"
echo "错误日志: $ERROR_LOG_FILE"
echo "配置方式: JAR包内配置（application-prod.yml）"
echo "启动参数: --spring.profiles.active=prod"
echo ""

# 启动应用（使用生产环境配置）
# JVM参数在 -jar 之前，Spring Boot参数在 JAR 文件之后
nohup java \
    -Xms512m \
    -Xmx1024m \
    -jar ${JAR_FILE} \
    --spring.profiles.active=prod \
    > ${LOG_FILE} 2>&1 &

# 保存PID
echo $! > $PID_FILE

# 等待一下，检查是否启动成功
sleep 3

# 检查进程是否还在运行
NEW_PID=$(cat $PID_FILE)
if ps -p $NEW_PID > /dev/null 2>&1; then
    echo "✅ 应用启动成功！"
    echo "   PID: $NEW_PID"
    echo "   所有日志: $LOG_FILE"
    echo "   错误日志: $ERROR_LOG_FILE"
    echo ""
    echo "📋 查看日志命令:"
    echo "   所有日志: tail -f $LOG_FILE 或 ./logs.sh"
    echo "   错误日志: tail -f $ERROR_LOG_FILE 或 ./logs-error.sh"
    echo ""
    echo "🛑 停止应用命令:"
    echo "   ./stop.sh"
else
    echo "❌ 应用启动失败！"
    echo "   请查看日志: tail -100 $LOG_FILE"
    rm -f $PID_FILE
    exit 1
fi
