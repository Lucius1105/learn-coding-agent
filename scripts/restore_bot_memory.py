#!/usr/bin/env python3
"""
Bot 记忆恢复脚本
供飞书 Bot 启动时调用
"""

import os
import re
from datetime import datetime

def read_file(filepath, lines=50):
    """读取文件前 N 行"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            return '\n'.join(f.readlines()[:lines])
    except Exception as e:
        return f"❌ 读取失败: {e}"

def extract_key_info(content):
    """提取关键信息"""
    # 提取标题和列表项
    key_points = []
    for line in content.split('\n'):
        if line.startswith('## ') or line.startswith('- [') or line.startswith('### '):
            key_points.append(line.strip())
    return key_points[:15]  # 限制数量

def restore_memory():
    """恢复 Bot 记忆"""
    print("=" * 60)
    print("🧠 Bot 记忆恢复启动")
    print("=" * 60)
    print()
    
    memory_summary = []
    
    # 1. 读取 MEMORY.md
    print("📖 读取 MEMORY.md...")
    memory_md = os.path.expanduser('~/.openclaw/workspace/MEMORY.md')
    if os.path.exists(memory_md):
        content = read_file(memory_md, 30)
        key_points = extract_key_info(content)
        print("✅ 已加载关键信息：")
        for point in key_points:
            print(f"   {point}")
        memory_summary.append(f"长期记忆: {len(key_points)} 条")
    else:
        print("⚠️  MEMORY.md 不存在")
        memory_summary.append("长期记忆: 无")
    print()
    
    # 2. 读取今日记忆
    print("📖 读取今日记忆...")
    today = datetime.now().strftime('%Y-%m-%d')
    today_md = os.path.expanduser(f'~/.openclaw/workspace/memory/{today}.md')
    if os.path.exists(today_md):
        content = read_file(today_md, 20)
        key_points = extract_key_info(content)
        print("✅ 已加载今日记忆：")
        for point in key_points:
            print(f"   {point}")
        memory_summary.append(f"今日记忆: {len(key_points)} 条")
    else:
        print(f"⚠️  {today}.md 不存在")
        memory_summary.append("今日记忆: 无")
    print()
    
    # 3. 读取 TODO.md
    print("📖 读取 TODO.md...")
    todo_md = os.path.expanduser('~/.openclaw/workspace/01_Projects/TODO.md')
    if os.path.exists(todo_md):
        content = read_file(todo_md, 30)
        # 提取未完成任务
        undone = re.findall(r'- \[ \] (.+)', content)
        print(f"✅ 已加载待办事项（{len(undone)} 个未完成任务）：")
        for task in undone[:10]:
            print(f"   ☐ {task}")
        memory_summary.append(f"待办事项: {len(undone)} 个")
    else:
        print("⚠️  TODO.md 不存在")
        memory_summary.append("待办事项: 无")
    print()
    
    # 4. Memory-OS 状态
    print("🧠 Memory-OS 状态...")
    memory_os = os.path.expanduser('~/.memory-os')
    if os.path.exists(memory_os):
        print("✅ Memory-OS 已配置，语义搜索可用")
        memory_summary.append("Memory-OS: 可用")
    else:
        print("⚠️  Memory-OS 未配置")
        memory_summary.append("Memory-OS: 未配置")
    print()
    
    # 5. 生成摘要
    print("=" * 60)
    print("✅ 记忆恢复完成")
    print("=" * 60)
    print()
    print("📊 记忆摘要：")
    for item in memory_summary:
        print(f"   • {item}")
    print()
    
    # 返回摘要供 Bot 使用
    return {
        'status': 'success',
        'summary': memory_summary,
        'long_term': os.path.exists(memory_md),
        'today': os.path.exists(today_md),
        'todo': os.path.exists(todo_md),
        'memory_os': os.path.exists(memory_os)
    }

if __name__ == '__main__':
    result = restore_memory()
    
    # 输出 Bot 问候语
    print("🤖 Bot 启动问候：")
    print()
    print("市场总监已上线，记忆恢复完成。")
    print()
    print(f"📅 今日：{datetime.now().strftime('%Y-%m-%d %H:%M')}")
    print(f"📊 记忆状态：{' | '.join(result['summary'])}")
    print()
    print("有什么需要我协助？")
