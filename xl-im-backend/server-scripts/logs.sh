#!/bin/bash
# XL-IM 查看所有日志脚本

APP_DIR="/www/wwwroot/xl-im"
LOG_FILE="${APP_DIR}/logs/xl-im.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "❌ 日志文件不存在: $LOG_FILE"
    echo "   应用可能还未启动，请先执行: ./start.sh"
    exit 1
fi

echo "=========================================="
echo "XL-IM 后端所有日志 (实时查看，按Ctrl+C退出)"
echo "=========================================="
echo "日志文件: $LOG_FILE"
echo ""

# 显示最后100行，然后实时跟踪
tail -n 100 -f $LOG_FILE

