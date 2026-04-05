#!/bin/bash
# 多 Bot 记忆写入锁机制
# 用法: ./memory-lock.sh <bot-name> <command>

LOCK_DIR="$HOME/.openclaw/workspace/.locks"
LOCK_FILE="$LOCK_DIR/memory.lock"
BOT_NAME="$1"
shift

# 创建锁目录
mkdir -p "$LOCK_DIR"

# 获取锁（最多等待 30 秒）
acquire_lock() {
    local wait_count=0
    while [ -f "$LOCK_FILE" ]; do
        if [ $wait_count -ge 30 ]; then
            echo "ERROR: 无法获取记忆锁，等待超时"
            exit 1
        fi
        sleep 1
        wait_count=$((wait_count + 1))
    done
    
    # 创建锁文件
    echo "$BOT_NAME:$(date +%s)" > "$LOCK_FILE"
    return 0
}

# 释放锁
release_lock() {
    if [ -f "$LOCK_FILE" ]; then
        rm -f "$LOCK_FILE"
    fi
}

# 执行命令
acquire_lock
"$@"
EXIT_CODE=$?
release_lock

exit $EXIT_CODE
