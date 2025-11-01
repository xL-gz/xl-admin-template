#!/bin/bash
# XL-IM 后端重启脚本

APP_DIR="/www/wwwroot/xl-im"

echo "=========================================="
echo "重启 XL-IM 后端服务..."
echo "=========================================="

cd $APP_DIR

# 停止应用
./stop.sh

# 等待2秒
sleep 2

# 启动应用
./start.sh

