#!/bin/bash
# XL-IM 状态查看脚本

APP_DIR="/www/wwwroot/xl-im"
PID_FILE="${APP_DIR}/xl-im.pid"
LOG_FILE="${APP_DIR}/logs/xl-im.log"

echo "=========================================="
echo "XL-IM 后端服务状态"
echo "=========================================="

# 检查PID文件
if [ -f "$PID_FILE" ]; then
    PID=$(cat $PID_FILE)
    if ps -p $PID > /dev/null 2>&1; then
        echo "✅ 状态: 运行中"
        echo "   PID: $PID"
        echo "   启动时间: $(ps -p $PID -o lstart= 2>/dev/null || echo '未知')"
        MEM=$(ps -p $PID -o rss= 2>/dev/null | awk '{printf "%.2f MB\n", $1/1024}')
        CPU=$(ps -p $PID -o %cpu= 2>/dev/null)
        echo "   内存使用: ${MEM:-未知}"
        echo "   CPU使用: ${CPU:-未知}%"
        
        # 检查端口
        PORT=$(netstat -tlnp 2>/dev/null | grep $PID | grep -oP ':\d+' | head -1 | tr -d ':' || ss -tlnp 2>/dev/null | grep $PID | grep -oP ':\d+' | head -1 | tr -d ':')
        if [ ! -z "$PORT" ]; then
            echo "   监听端口: $PORT"
        fi
    else
        echo "⚠️  状态: PID文件存在但进程不存在"
        echo "   PID文件: $PID_FILE"
    fi
else
    # 尝试通过进程名查找
    PID=$(ps aux | grep "xl-im-admin-1.0.0.jar" | grep -v grep | awk '{print $2}')
    if [ ! -z "$PID" ]; then
        echo "✅ 状态: 运行中（未找到PID文件）"
        echo "   PID: $PID"
    else
        echo "❌ 状态: 未运行"
    fi
fi

echo ""
echo "所有日志: $LOG_FILE"
if [ -f "$LOG_FILE" ]; then
    echo "日志大小: $(du -h $LOG_FILE | cut -f1)"
    echo "最后更新: $(stat -c %y $LOG_FILE 2>/dev/null | cut -d. -f1 || echo '未知')"
fi

ERROR_LOG_FILE="${APP_DIR}/logs/xl-imerror.log"
echo ""
echo "错误日志: $ERROR_LOG_FILE"
if [ -f "$ERROR_LOG_FILE" ]; then
    ERROR_SIZE=$(du -h $ERROR_LOG_FILE | cut -f1)
    ERROR_COUNT=$(wc -l < $ERROR_LOG_FILE 2>/dev/null || echo "0")
    echo "日志大小: $ERROR_SIZE"
    echo "错误条数: $ERROR_COUNT"
    echo "最后更新: $(stat -c %y $ERROR_LOG_FILE 2>/dev/null | cut -d. -f1 || echo '未知')"
else
    echo "暂无错误日志"
fi

