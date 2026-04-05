# ERRORS.md - 错误记录

> 记录命令失败、异常、API 错误和意外行为。
> 来源：self-improving-agent skill

---

## 格式模板

```markdown
## [ERR-YYYYMMDD-XXX] skill_or_command_name

**Logged**: ISO-8601 timestamp
**Priority**: high
**Status**: pending | in_progress | resolved | wont_fix
**Area**: frontend | backend | infra | tests | docs | config

### Summary
简要描述什么失败了

### Error
```
实际错误信息或输出
```

### Context
- 尝试的命令/操作
- 使用的输入或参数
- 相关环境细节

### Suggested Fix
如果可以识别，可能的解决方案

### Metadata
- Reproducible: yes | no | unknown
- Related Files: path/to/file.ext
- See Also: ERR-20250110-001 (重复问题)

### Resolution (解决后填写)
- **Resolved**: YYYY-MM-DDTHH:MM:SSZ
- **Commit/PR**: abc123 or #42
- **Notes**: 修复简述

---
```

---

## 错误记录

## [ERR-20250329-001] Kimi K2.5 Context Length Limit

**Logged**: 2026-03-29T19:00:00+08:00
**Priority**: high
**Status**: resolved
**Area**: infra

### Summary
Kimi K2.5 模型触发 HTTP 400 错误，会话上下文超过 260096 tokens 限制

### Error
```
HTTP 400: <400> InternalError.Algo.InvalidParameter: 
Range of input length should be [1, 260096]
```

### Context
- 会话运行时间较长，累积了大量消息历史
- 可能还加载了多个大文件
- 触发时正在进行复杂任务

### Suggested Fix
1. 定期使用 `/new` 重置会话
2. 避免在单个会话中加载过多文件
3. 重要信息及时写入 MEMORY.md，不依赖会话记忆

### Metadata
- Reproducible: yes
- Related Files: ~/.openclaw/workspace/MEMORY.md
- See Also: (无)

### Resolution
- **Resolved**: 2026-03-29T19:00:00+08:00
- **Notes**: 使用 `/new` 重置会话后恢复正常。已提醒用户定期重置以避免此问题。

---

### 待记录

- [ ] (暂无)

---

*创建时间: 2026-03-29*
*技能: self-improving-agent*
