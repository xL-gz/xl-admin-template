#!/bin/bash
# XL-IM 查看错误日志脚本

APP_DIR="/www/wwwroot/xl-im"
ERROR_LOG_FILE="${APP_DIR}/logs/xl-imerror.log"

if [ ! -f "$ERROR_LOG_FILE" ]; then
    echo "❌ 错误日志文件不存在: $ERROR_LOG_FILE"
    echo "   应用可能还未启动，或还没有错误日志"
    echo "   请先执行: ./start.sh"
    exit 1
fi

echo "=========================================="
echo "XL-IM 后端错误日志 (实时查看，按Ctrl+C退出)"
echo "=========================================="
echo "错误日志文件: $ERROR_LOG_FILE"
echo ""

# 显示最后100行，然后实时跟踪
tail -n 100 -f $ERROR_LOG_FILE

