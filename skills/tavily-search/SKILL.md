---
name: tavily
description: |
  AI-optimized web search via Tavily API. Returns concise, relevant results for AI agents.
  触发词: 联网搜索、联网、search、lookup
homepage: https://tavily.com
metadata: {"clawdbot":{"emoji":"🔍","requires":{"bins":["node"],"env":["TAVILY_API_KEY"]},"primaryEnv":"TAVILY_API_KEY"}}
---

# Tavily Search 🔍

AI-optimized web search using Tavily API. Designed for AI agents - returns clean, relevant content.

## 触发条件

用户输入以下关键词时激活：
- `联网搜索` / `联网`（中文）
- `search` / `lookup` / `查找`（英文/中文）
- `搜索一下` / `查一下` / `帮我搜`

## 使用示例

```
联网搜索 水杨酸爽肤水 干性皮肤 每天用
联网 杏仁酸 皮肤科建议
search "quantum computing"
```

## Search

```bash
node {baseDir}/scripts/search.mjs "query"
node {baseDir}/scripts/search.mjs "query" -n 10
node {baseDir}/scripts/search.mjs "query" --deep
node {baseDir}/scripts/search.mjs "query" --topic news
```

## Options

- `-n <count>`: Number of results (default: 5, max: 20)
- `--deep`: Use advanced search for deeper research (slower, more comprehensive)
- `--topic <topic>`: Search topic - `general` (default) or `news`
- `--days <n>`: For news topic, limit to last n days

## Extract content from URL

```bash
node {baseDir}/scripts/extract.mjs "https://example.com/article"
```

Notes:
- Needs `TAVILY_API_KEY` from https://tavily.com
- Tavily is optimized for AI - returns clean, relevant snippets
- Use `--deep` for complex research questions
- Use `--topic news` for current events
