# Tavily Search 配置说明

## 状态
✅ 已配置完成

## API Key
- Key: `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`
- 来源：老徐提供
- 状态：有效

## 可用脚本

### 1. 通用搜索
```bash
/Users/lucius/.openclaw/workspace/skills/tavily-search/scripts/search.sh "搜索关键词" -n 5 --topic news --days 3
```

参数：
- `-n <count>`: 结果数量（默认5）
- `--topic <general|news>`: 搜索主题
- `--days <n>`: 新闻主题时限定天数
- `--deep`: 深度搜索（更慢但更全面）

### 2. 每日简报
```bash
/Users/lucius/.openclaw/workspace/skills/tavily-search/scripts/daily-briefing.sh
```

自动搜索：
- AI行业动态
- 商业案例
- 教练行业动态
- 创业者相关

## 使用场景

### 场景1：生成朋友圈文案
1. 运行每日简报获取热点
2. 结合老徐的内容方向生成文案
3. 输出到 output/ 目录

### 场景2：选题方向建议
1. 搜索相关领域最新动态
2. 分析哪些热点适合老徐风格
3. 给出3-5个选题建议

### 场景3：内容润色
1. 搜索相关案例/数据支撑
2. 补充到文案中增加可信度

## 下一步
- [ ] 配置每日9点自动运行简报生成
- [ ] 集成到朋友圈文案生成工作流
- [ ] 添加飞书自动推送功能