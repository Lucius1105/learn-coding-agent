#!/bin/bash
# enable-sleep.sh - 恢复 MacBook 默认电源设置
# 雨后甘霖 - 市场总监配置脚本

echo "=== 正在恢复默认电源管理设置 ==="

# 恢复默认睡眠设置（连接电源时10分钟）
sudo pmset -c sleep 10
echo "✓ 已恢复连接电源时的睡眠设置"

# 恢复显示器睡眠（连接电源时10分钟）
sudo pmset -c displaysleep 10
echo "✓ 已恢复显示器睡眠设置"

# 恢复硬盘睡眠
sudo pmset -c disksleep 10
echo "✓ 已恢复硬盘睡眠设置"

# 恢复待机模式
sudo pmset -c standby 1
echo "✓ 已恢复待机模式"

# 恢复 Power Nap
sudo pmset -c powernap 1
echo "✓ 已恢复 Power Nap"

# 恢复休眠模式（安全睡眠）
sudo pmset -c hibernatemode 3
echo "✓ 已恢复休眠模式"

# 恢复合盖睡眠
sudo pmset -c disablesleep 0
echo "✓ 已恢复合盖睡眠"

echo ""
echo "=== 当前电源设置 ==="
pmset -g custom

echo ""
echo "=== 完成 ==="
echo "已恢复默认电源管理设置"
