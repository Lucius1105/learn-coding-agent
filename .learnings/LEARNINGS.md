# LEARNINGS.md - 学习记录与改进日志

> 记录学到的知识、用户纠正、最佳实践和知识缺口。
> 来源：self-improving-agent skill

---

## 格式模板

```markdown
## [LRN-YYYYMMDD-XXX] category

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: pending | in_progress | resolved | promoted | wont_fix
**Area**: frontend | backend | infra | tests | docs | config | content | workflow

### Summary
一句话描述学到了什么

### Details
完整上下文：发生了什么、哪里错了、正确的是什么

### Suggested Action
具体的修复或改进建议

### Metadata
- Source: conversation | error | user_feedback | self_discovery
- Related Files: path/to/file.ext
- Tags: tag1, tag2
- See Also: LRN-20250110-001 (相关条目)
- Pattern-Key: (可选，用于重复模式追踪)
- Recurrence-Count: 1 (可选)
- First-Seen: YYYY-MM-DD (可选)
- Last-Seen: YYYY-MM-DD (可选)

---
```

---

## 学习记录

## [LRN-20250329-001] knowledge_gap

**Logged**: 2026-03-29T19:00:00+08:00
**Priority**: high
**Status**: resolved
**Area**: infra

### Summary
Kimi K2.5 有 260096 tokens 的输入长度限制，长会话会触发 HTTP 400 错误

### Details
之前不知道 Kimi K2.5 有明确的上下文长度限制。当会话累积太多消息或加载太多文件时，会触发 `InternalError.Algo.InvalidParameter` 错误。这不是飞书或 OpenClaw 的问题，是模型层面的限制。

### Suggested Action
1. 长会话定期使用 `/new` 重置
2. 重要信息写入 MEMORY.md，不依赖会话记忆
3. 避免单次加载过多大文件

### Metadata
- Source: error
- Related Files: ~/.openclaw/workspace/MEMORY.md
- Tags: kimi, context-limit, error-handling
- See Also: ERR-20250329-001

---

## [LRN-20250329-002] best_practice

**Logged**: 2026-03-29T19:10:00+08:00
**Priority**: medium
**Status**: pending
**Area**: workflow

### Summary
成功安装并测试了 openclaw-memory-os (Memory-OS) 技能

### Details
Memory-OS 是一个"数字永生服务与认知延续基础设施"，提供：
- 多源记忆收集（聊天、文件、代码、媒体）
- 语义搜索（需要配置 embedding provider）
- 时间线追踪
- 知识图谱（计划中）

安装步骤：
1. 安装 Node.js (v20.12.0)
2. npm install + npm run build
3. npm link
4. 使用 `node dist/cli/index.js` 运行

当前状态：
- 基础功能正常（init, remember, status）
- 语义搜索需要配置 OpenAI API key 才能工作
- 存储位置：~/.memory-os

### Suggested Action
1. 配置 embedding provider 以启用语义搜索
2. 集成到 A1989 工作流中，自动保存重要对话
3. 评估与现有 memory_search 工具的关系

### Metadata
- Source: self_discovery
- Related Files: ~/.openclaw/skills/openclaw-memory-os/
- Tags: memory-os, skill-installation, nodejs
- See Also: FEAT-20250329-001

---

## [LRN-20250329-003] best_practice

**Logged**: 2026-03-29T20:50:00+08:00
**Priority**: high
**Status**: resolved
**Area**: workflow

### Summary
成功配置 Memory-OS 本地 Embedding，实现完全免费的语义搜索

### Details
安装了 @xenova/transformers，配置了本地 embedding 模型 Xenova/all-MiniLM-L6-v2。测试搜索"商业教练"成功返回相关记忆，语义匹配正常工作。

配置命令：
```
node dist/cli/index.js config set embedding.provider local
node dist/cli/index.js config set embedding.model Xenova/all-MiniLM-L6-v2
```

### Suggested Action
1. 继续使用本地 embedding，完全免费
2. 首次使用会下载模型（约80MB）到 ~/.cache/
3. 速度比 API 慢但完全够用

### Metadata
- Source: self_discovery
- Related Files: ~/.openclaw/skills/openclaw-memory-os/
- Tags: memory-os, embedding, local-model, free
- See Also: FEAT-20250329-001

---

## [LRN-20250329-004] best_practice

**Logged**: 2026-03-29T20:55:00+08:00
**Priority**: medium
**Status**: resolved
**Area**: workflow

### Summary
创建了多 Bot 并发写入保护机制（文件锁）

### Details
飞书 8 个 Bot 共享同一个 A1989 后端，可能有并发写入冲突。创建了简单的文件锁脚本：
- 位置：~/.openclaw/workspace/scripts/memory-lock.sh
- 用法：./memory-lock.sh <bot-name> <command>
- 机制：获取锁 → 执行命令 → 释放锁
- 超时：最多等待 30 秒

### Suggested Action
1. 在写入 MEMORY.md 前调用锁机制
2. 或使用 Memory-OS 作为统一存储层（它有自己的索引机制）

### Metadata
- Source: self_discovery
- Related Files: ~/.openclaw/workspace/scripts/memory-lock.sh
- Tags: multi-bot, concurrency, file-lock
- See Also: FEAT-20250329-002

---

### 待记录

- [ ] (暂无)

---

*创建时间: 2026-03-29*
*技能: self-improving-agent*
