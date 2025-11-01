#!/bin/bash
# XL-IM 后端停止脚本

APP_DIR="/www/wwwroot/xl-im"
PID_FILE="${APP_DIR}/xl-im.pid"
APP_NAME="xl-im-admin"

echo "=========================================="
echo "停止 XL-IM 后端服务..."
echo "=========================================="

# 方式一：通过PID文件停止
if [ -f "$PID_FILE" ]; then
    PID=$(cat $PID_FILE)
    if ps -p $PID > /dev/null 2>&1; then
        echo "找到进程 PID: $PID"
        kill $PID
        
        # 等待进程结束（最多等待30秒）
        for i in {1..30}; do
            if ! ps -p $PID > /dev/null 2>&1; then
                echo "✅ 应用已停止"
                rm -f $PID_FILE
                exit 0
            fi
            sleep 1
            echo -n "."
        done
        
        # 如果30秒后还在运行，强制杀死
        if ps -p $PID > /dev/null 2>&1; then
            echo ""
            echo "⚠️  正常停止超时，强制停止进程..."
            kill -9 $PID
            sleep 2
            if ! ps -p $PID > /dev/null 2>&1; then
                echo "✅ 应用已强制停止"
                rm -f $PID_FILE
            else
                echo "❌ 停止失败，请手动检查"
                exit 1
            fi
        fi
    else
        echo "⚠️  PID文件存在，但进程不存在，清理PID文件"
        rm -f $PID_FILE
    fi
else
    echo "⚠️  未找到PID文件，尝试通过进程名停止..."
    
    # 方式二：通过进程名停止
    PID=$(ps aux | grep "xl-im-admin-1.0.0.jar" | grep -v grep | awk '{print $2}')
    
    if [ -z "$PID" ]; then
        echo "❌ 未找到运行中的应用"
        exit 1
    fi
    
    echo "找到进程 PID: $PID"
    kill $PID
    sleep 3
    
    if ps -p $PID > /dev/null 2>&1; then
        echo "强制停止进程..."
        kill -9 $PID
    fi
    
    echo "✅ 应用已停止"
fi

