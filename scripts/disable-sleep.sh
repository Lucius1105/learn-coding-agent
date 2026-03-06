#!/bin/bash
# disable-sleep.sh - 禁用 MacBook 待机和休眠功能
# 雨后甘霖 - 市场总监配置脚本

echo "=== 正在配置电源管理设置 ==="

# 禁用系统睡眠（连接电源时）
sudo pmset -c sleep 0
echo "✓ 已禁用连接电源时的睡眠"

# 禁用系统睡眠（电池供电时）- 可选，根据需要开启
# sudo pmset -b sleep 0

# 禁用显示器睡眠（连接电源时）
sudo pmset -c displaysleep 0
echo "✓ 已禁用连接电源时的显示器睡眠"

# 禁用硬盘睡眠
sudo pmset -c disksleep 0
echo "✓ 已禁用硬盘睡眠"

# 防止系统在闲置时进入待机（standby）
sudo pmset -c standby 0
echo "✓ 已禁用待机模式"

# 禁用 Power Nap
sudo pmset -c powernap 0
echo "✓ 已禁用 Power Nap"

# 禁用休眠（hibernate）- 将内存写入磁盘的功能
sudo pmset -c hibernatemode 0
echo "✓ 已禁用休眠模式"

# 设置关闭盖子时不采取任何操作（需要连接外部显示器和电源）
sudo pmset -c disablesleep 1
echo "✓ 已设置合盖不休眠（需连接电源和显示器）"

echo ""
echo "=== 当前电源设置 ==="
pmset -g custom

echo ""
echo "=== 完成 ==="
echo "笔记本将在连接电源时保持持续在线状态"
echo "如需恢复默认设置，请运行: ./enable-sleep.sh"
