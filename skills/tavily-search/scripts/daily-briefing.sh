#!/bin/bash
# 每日简报生成脚本 - 为老徐生成朋友圈内容素材

TAVILY_API_KEY="${TAVILY_API_KEY:-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}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 搜索函数
tavily_search() {
    local query="$1"
    local max_results="${2:-3}"
    local topic="${3:-general}"
    local days="${4:-7}"
    
    curl -s -X POST "https://api.tavily.com/search" \
        -H "Content-Type: application/json" \
        -d "{
            \"api_key\": \"$TAVILY_API_KEY\",
            \"query\": \"$query\",
            \"search_depth\": \"basic\",
            \"topic\": \"$topic\",
            \"max_results\": $max_results,
            \"include_answer\": true,
            \"days\": $days
        }" 2>/dev/null
}

echo "=== 老徐每日简报 · $(date '+%Y-%m-%d') ==="
echo ""

# 1. AI行业动态
echo "📱 AI行业动态"
echo "---"
AI_RESULT=$(tavily_search "AI人工智能最新动态 商业应用" 3 "news" 2)
echo "$AI_RESULT" | grep -o '"answer":"[^"]*"' | head -1 | sed 's/"answer":"//;s/"$//' | fold -s -w 80
echo ""

# 2. 商业案例
echo "💼 商业案例"
echo "---"
BUSINESS_RESULT=$(tavily_search "品牌营销案例 创业者 2025" 2 "news" 7)
echo "$BUSINESS_RESULT" | grep -o '"answer":"[^"]*"' | head -1 | sed 's/"answer":"//;s/"$//' | fold -s -w 80
echo ""

# 3. 教练行业动态
echo "🎯 教练行业动态"
echo "---"
COACH_RESULT=$(tavily_search "ICF教练 商业教练 行业动态" 2 "news" 7)
echo "$COACH_RESULT" | grep -o '"answer":"[^"]*"' | head -1 | sed 's/"answer":"//;s/"$//' | fold -s -w 80
echo ""

# 4. 创业者相关
echo "🚀 创业者相关"
echo "---"
FOUNDER_RESULT=$(tavily_search "创业者 中小企业 经营策略" 2 "news" 7)
echo "$FOUNDER_RESULT" | grep -o '"answer":"[^"]*"' | head -1 | sed 's/"answer":"//;s/"$//' | fold -s -w 80
echo ""

echo "=== 简报生成完成 ==="