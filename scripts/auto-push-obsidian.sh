#!/bin/bash
# auto-push-obsidian.sh - 自动推送A1989本地更改到远程服务器
# 规则：保存文件后立即调用此脚本，但29分和59分推迟2分钟

LOG_FILE="/Users/lucius/auto-push.log"
CURRENT_MIN=$(date +%M)

# 检查是否在29或59分（规避冲突窗口）
if [[ "$CURRENT_MIN" == "29" || "$CURRENT_MIN" == "59" ]]; then
    echo "$(date): 当前为${CURRENT_MIN}分，推迟2分钟推送以避免冲突" >> $LOG_FILE
    sleep 120
fi

# 执行推送
cd /Users/lucius/obsidian-mirror
echo "$(date): 开始推送本地更改到远程..." >> $LOG_FILE
rsync -az . luciusxu@192.168.50.2:obsidian-vault/ --delete 2>&1 >> $LOG_FILE
echo "$(date): 推送完成" >> $LOG_FILE
