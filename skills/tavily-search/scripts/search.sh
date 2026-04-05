#!/bin/bash
# Tavily Search Script - Shell版本

TAVILY_API_KEY="${TAVILY_API_KEY:-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}"

# 解析参数
QUERY=""
MAX_RESULTS=5
SEARCH_DEPTH="basic"
TOPIC="general"
DAYS=7

while [[ $# -gt 0 ]]; do
  case $1 in
    -n|--max-results)
      MAX_RESULTS="$2"
      shift 2
      ;;
    --deep)
      SEARCH_DEPTH="advanced"
      shift
      ;;
    --topic)
      TOPIC="$2"
      shift 2
      ;;
    --days)
      DAYS="$2"
      shift 2
      ;;
    -*)
      echo "Unknown option: $1"
      exit 1
      ;;
    *)
      QUERY="$1"
      shift
      ;;
  esac
done

if [ -z "$QUERY" ]; then
  echo "Usage: $0 <query> [-n <count>] [--deep] [--topic <general|news>] [--days <n>]"
  exit 1
fi

# 构建JSON请求
JSON_PAYLOAD=$(cat <<EOF
{
  "api_key": "$TAVILY_API_KEY",
  "query": "$QUERY",
  "search_depth": "$SEARCH_DEPTH",
  "topic": "$TOPIC",
  "max_results": $MAX_RESULTS,
  "include_answer": true,
  "include_raw_content": false
}
EOF
)

# 添加 days 参数（仅news主题）
if [ "$TOPIC" = "news" ]; then
  JSON_PAYLOAD=$(echo "$JSON_PAYLOAD" | sed "s/}$/, \"days\": $DAYS }/")
fi

# 调用API
curl -s -X POST "https://api.tavily.com/search" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD"