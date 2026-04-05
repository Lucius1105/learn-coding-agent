#!/bin/bash
# Bot 记忆恢复脚本
# 每个 Bot 启动时自动执行

echo "========================================"
echo "Bot 记忆恢复启动"
echo "========================================"
echo ""

# 1. 读取 MEMORY.md
echo "📖 读取 MEMORY.md..."
if [ -f ~/.openclaw/workspace/MEMORY.md ]; then
    echo "✅ MEMORY.md 已加载"
    # 提取关键信息
    grep -E "^## |^- |^\*" ~/.openclaw/workspace/MEMORY.md | head -20
else
    echo "⚠️  MEMORY.md 不存在"
fi
echo ""

# 2. 读取今日记忆
echo "📖 读取今日记忆..."
TODAY=$(date +%Y-%m-%d)
if [ -f ~/.openclaw/workspace/memory/${TODAY}.md ]; then
    echo "✅ ${TODAY}.md 已加载"
    head -30 ~/.openclaw/workspace/memory/${TODAY}.md
else
    echo "⚠️  今日记忆文件不存在"
fi
echo ""

# 3. 读取 TODO.md
echo "📖 读取 TODO.md..."
if [ -f ~/.openclaw/workspace/01_Projects/TODO.md ]; then
    echo "✅ TODO.md 已加载"
    grep -E "^- \[ \]|^### " ~/.openclaw/workspace/01_Projects/TODO.md | head -15
else
    echo "⚠️  TODO.md 不存在"
fi
echo ""

# 4. Memory-OS 状态
echo "🧠 Memory-OS 状态..."
if [ -d ~/.memory-os ]; then
    echo "✅ Memory-OS 已配置"
    ls ~/.memory-os/
else
    echo "⚠️  Memory-OS 未配置"
fi
echo ""

echo "========================================"
echo "记忆恢复完成"
echo "========================================"
