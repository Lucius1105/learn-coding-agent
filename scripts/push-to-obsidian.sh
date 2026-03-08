#!/bin/bash
# push-to-obsidian.sh - 推送OpenClaw产出到Obsidian知识库
# 雨后甘霖 - A1989配置

SOURCE_DIR="/Users/lucius/.openclaw/workspace/output"
TARGET_DIR="/Users/lucius/obsidian-mirror/📁PARA-Obsidian/📁 1-Projects（项目）/06 🆕雨后甘霖知识库 2.0/📁 10_OpenClaw产出_待审核"
LOG_FILE="/Users/lucius/.openclaw/workspace/.openclaw/sync-push.log"

echo "=== OpenClaw → Obsidian 推送 ===" | tee -a "$LOG_FILE"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
echo "源目录: $SOURCE_DIR" | tee -a "$LOG_FILE"
echo "目标目录: $TARGET_DIR" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 检查源目录
if [ ! -d "$SOURCE_DIR" ]; then
    echo "错误: 源目录不存在" | tee -a "$LOG_FILE"
    exit 1
fi

# 创建目标目录（如果不存在）
mkdir -p "$TARGET_DIR"

# 复制所有文件
echo "开始复制文件..." | tee -a "$LOG_FILE"
cp -v "$SOURCE_DIR"/*.md "$TARGET_DIR/" 2>&1 | tee -a "$LOG_FILE"

# 统计
echo "" | tee -a "$LOG_FILE"
echo "推送完成！" | tee -a "$LOG_FILE"
echo "文件数量: $(ls -1 "$TARGET_DIR"/*.md 2>/dev/null | wc -l)" | tee -a "$LOG_FILE"
echo "总大小: $(du -sh "$TARGET_DIR" | awk '{print $1}')" | tee -a "$LOG_FILE"
echo "=== 结束 ===" | tee -a "$LOG_FILE"
