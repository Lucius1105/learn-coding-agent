# FEATURE_REQUESTS.md - 功能请求

> 记录用户请求的新功能、能力或改进。
> 来源：self-improving-agent skill

---

## 格式模板

```markdown
## [FEAT-YYYYMMDD-XXX] capability_name

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: pending | in_progress | resolved | wont_fix
**Area**: frontend | backend | infra | tests | docs | config | content | workflow

### Requested Capability
用户想要做什么

### User Context
为什么需要这个功能，解决什么问题

### Complexity Estimate
simple | medium | complex

### Suggested Implementation
如何构建，可能扩展什么

### Metadata
- Frequency: first_time | recurring
- Related Features: existing_feature_name

### Resolution (解决后填写)
- **Resolved**: YYYY-MM-DDTHH:MM:SSZ
- **Status**: implemented | declined | duplicate
- **Notes**: 处理结果

---
```

---

## 功能请求

## [FEAT-20250329-001] Memory-OS Semantic Search Configuration

**Logged**: 2026-03-29T19:10:00+08:00
**Priority**: medium
**Status**: pending
**Area**: infra

### Requested Capability
配置 Memory-OS 的语义搜索功能，使其能够进行 AI 驱动的记忆检索

### User Context
Memory-OS 已安装成功，但语义搜索需要配置 embedding provider（如 OpenAI）才能正常工作。当前只能使用基础的关键词搜索。

### Complexity Estimate
simple

### Suggested Implementation
1. 配置 OpenAI API key：`openclaw-memory-os config set embedding.apiKey $OPENAI_API_KEY`
2. 或使用本地 embedding 模型以减少 API 成本
3. 测试语义搜索功能

### Metadata
- Frequency: first_time
- Related Features: openclaw-memory-os, memory_search

---

## [FEAT-20250329-002] Multi-Bot Memory Sharing & Concurrency Control

**Logged**: 2026-03-29T19:15:00+08:00
**Priority**: high
**Status**: pending
**Area**: workflow

### Requested Capability
解决飞书 8 个 Bot 共享记忆时的并发写入冲突问题

### User Context
飞书 8 个 Bot（战略顾问、市场总监等）都对接同一个 A1989 后端，共享 ~/.openclaw/workspace/ 下的记忆文件。如果多个 Bot 同时触发，可能有并发写入冲突风险。

### Complexity Estimate
medium

### Suggested Implementation
1. 评估 OpenClaw 是否有内置的文件锁机制
2. 实现简单的写入队列或锁文件机制
3. 或者为每个 Bot 分配独立的记忆命名空间，定期合并

### Metadata
- Frequency: first_time
- Related Features: feishu-bot, memory-system

---

## [FEAT-20250329-003] Install Recommended Skills from Awesome List

**Logged**: 2026-03-29T20:55:00+08:00
**Priority**: medium
**Status**: pending
**Area**: workflow

### Requested Capability
从 awesome-openclaw-skills 列表安装推荐技能

### User Context
发现 5200+ 技能，筛选出适合雨后甘霖的。

### Complexity Estimate
medium

### Suggested Implementation
1. 从 github.com/openclaw/skills 克隆
2. 或直接创建简化版 skill

### Metadata
- Frequency: first_time
- Related Features: skill-installation, content-production

### Resolution
- **Status**: pending
- **Notes**: 已创建 brand-voice-profile，其余技能待后续安装

---

## [FEAT-20250329-004] Soul & Memory Module Alignment

**Logged**: 2026-03-29T21:10:00+08:00
**Priority**: high
**Status**: pending
**Area**: workflow

### Requested Capability
调教和对齐 A1989 的 SOUL.md 及记忆模块

### User Context
需要深度对齐 SOUL 文件和记忆模块架构，确保符合老徐的要求

### Complexity Estimate
medium

### Suggested Implementation
1. 读取当前 SOUL.md
2. 分析现有记忆系统
3. 根据反馈调整
4. 更新 MEMORY.md 架构

### Metadata
- Frequency: first_time
- Related Features: soul, memory, alignment

---

### 待记录

- [ ] (暂无)

---

*创建时间: 2026-03-29*
*技能: self-improving-agent*
