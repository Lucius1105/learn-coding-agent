#!/bin/bash
# obsidian-sync-monitor.sh - Obsidian知识库同步监控脚本
# 雨后甘霖 - 市场总监配置

LOG_FILE="/Users/lucius/obsidian-mirror/sync-monitor.log"
MIRROR_DIR="/Users/lucius/obsidian-mirror"
REMOTE_HOST="luciusxu@192.168.50.2"
REMOTE_VAULT="/Users/luciusxu/Library/Mobile Documents/iCloud~md~obsidian/Documents/阿徐文化有限的笔记库"
LOCK_FILE="/tmp/obsidian-sync.lock"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 检查是否已有同步在进行
if [ -f "$LOCK_FILE" ]; then
    LOCK_PID=$(cat "$LOCK_FILE" 2>/dev/null)
    if ps -p "$LOCK_PID" > /dev/null 2>&1; then
        log "同步进程 $LOCK_PID 仍在运行，跳过本次检查"
        exit 0
    else
        log "检测到僵死锁文件，清理后继续"
        rm -f "$LOCK_FILE"
    fi
fi

# 创建锁文件
echo $$ > "$LOCK_FILE"

log "=== 开始同步检查 ==="

# 检查本地目录大小
LOCAL_SIZE=$(du -sm "$MIRROR_DIR" 2>/dev/null | awk '{print $1}')
log "本地大小: ${LOCAL_SIZE}MB"

# 检查远程目录大小
REMOTE_SIZE=$(ssh "$REMOTE_HOST" "du -sm '$REMOTE_VAULT' 2>/dev/null | awk '{print \$1}'" 2>/dev/null)
if [ -z "$REMOTE_SIZE" ]; then
    log "错误: 无法连接到远程服务器或获取远程大小"
    rm -f "$LOCK_FILE"
    exit 1
fi
log "远程大小: ${REMOTE_SIZE}MB"

# 比较大小（允许10MB误差）
SIZE_DIFF=$((REMOTE_SIZE - LOCAL_SIZE))
if [ ${SIZE_DIFF#-} -lt 10 ]; then
    log "✓ 同步正常，差异仅 ${SIZE_DIFF}MB"
    rm -f "$LOCK_FILE"
    exit 0
fi

log "⚠ 检测到差异 ${SIZE_DIFF}MB，需要重新同步"

# 终止可能卡住的rsync进程
pkill -f "rsync.*obsidian-vault" 2>/dev/null
sleep 2

# 方法1: 尝试增量rsync
log "尝试增量同步..."
cd "$MIRROR_DIR" || exit 1

if rsync -avz --delete "$REMOTE_HOST:$REMOTE_VAULT/" . >> sync-monitor.log 2>&1; then
    NEW_SIZE=$(du -sm "$MIRROR_DIR" | awk '{print $1}')
    log "✓ 增量同步完成，新大小: ${NEW_SIZE}MB"
    rm -f "$LOCK_FILE"
    exit 0
fi

log "增量同步失败，尝试完整压缩传输..."

# 方法2: 压缩打包传输
BACKUP_FILE="obsidian-backup-$(date +%Y%m%d-%H%M).tar.gz"
if ssh "$REMOTE_HOST" "tar czf ~/$BACKUP_FILE -C '/Users/luciusxu/Library/Mobile Documents/iCloud~md~obsidian/Documents/' '阿徐文化有限的笔记库'" 2>/dev/null; then
    REMOTE_BACKUP_SIZE=$(ssh "$REMOTE_HOST" "du -sm ~/$BACKUP_FILE | awk '{print \$1}'" 2>/dev/null)
    log "远程打包完成: ${REMOTE_BACKUP_SIZE}MB"
    
    # 下载并解压
    cd /Users/lucius
    if scp "$REMOTE_HOST:$BACKUP_FILE" . 2>/dev/null; then
        cd "$MIRROR_DIR"
        rm -rf *
        if tar xzf "/Users/lucius/$BACKUP_FILE" --strip-components=1 2>/dev/null; then
            FINAL_SIZE=$(du -sm "$MIRROR_DIR" | awk '{print $1}')
            log "✓ 完整同步完成，最终大小: ${FINAL_SIZE}MB"
            # 清理临时文件
            rm -f "/Users/lucius/$BACKUP_FILE"
            ssh "$REMOTE_HOST" "rm -f ~/$BACKUP_FILE" 2>/dev/null
        else
            log "错误: 解压失败"
        fi
    else
        log "错误: 下载备份文件失败"
    fi
else
    log "错误: 远程打包失败"
fi

rm -f "$LOCK_FILE"
log "=== 检查结束 ==="
