#!/bin/bash
# 立即修复启动脚本 - 复制这个脚本内容到服务器上

cat > /www/wwwroot/xl-im/start.sh << 'SCRIPT_END'
#!/bin/bash
# XL-IM 后端启动脚本（支持环境变量配置）

APP_DIR="/www/wwwroot/xl-im"
APP_NAME="xl-im-admin"
JAR_FILE="${APP_DIR}/xl-im-admin-1.0.0.jar"
LOG_FILE="${APP_DIR}/logs/xl-im.log"
ERROR_LOG_FILE="${APP_DIR}/logs/xl-imerror.log"
PID_FILE="${APP_DIR}/xl-im.pid"
ENV_FILE="${APP_DIR}/.env"

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
        rm -f $PID_FILE
    fi
fi

# 加载环境变量文件（如果存在）
if [ -f "$ENV_FILE" ]; then
    echo "✅ 加载环境变量文件: $ENV_FILE"
    export $(cat $ENV_FILE | grep -v '^#' | xargs)
fi

# 设置Java环境变量
export JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-21-openjdk}
export PATH=$JAVA_HOME/bin:$PATH

echo "=========================================="
echo "启动 XL-IM 后端服务..."
echo "=========================================="
echo "应用目录: $APP_DIR"
echo "JAR文件: $JAR_FILE"
echo "所有日志: $LOG_FILE"
echo "错误日志: $ERROR_LOG_FILE"

if [ -f "$ENV_FILE" ]; then
    echo "配置方式: 环境变量文件 (.env)"
else
    echo "配置方式: JAR包内默认配置"
fi
echo ""

# 只使用JAR包内配置，不指定外部配置文件
echo "📦 使用JAR包内默认配置（生产环境）"
CONFIG_PARAM="-Dspring.profiles.active=prod"

# 启动应用
nohup java -jar \
    -Xms512m \
    -Xmx1024m \
    ${CONFIG_PARAM} \
    ${JAR_FILE} \
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
SCRIPT_END

chmod +x /www/wwwroot/xl-im/start.sh
echo "✅ 启动脚本已更新！"
echo "现在可以运行: ./start.sh"

