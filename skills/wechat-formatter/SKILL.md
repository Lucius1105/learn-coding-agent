# WeChat Formatter Skill

## Description

一键将 Markdown 文件转换为微信公众号可用的 HTML 格式，基于雨后甘霖 v2.0 排版规范（Inkflow升级版）。

## Usage

### 命令行使用

```bash
# 转换单个文件
openclaw skills run wechat-formatter --input /path/to/article.md --output /path/to/output.html

# 使用特定版本规范
openclaw skills run wechat-formatter --input article.md --version v2.0
```

### Python API

```python
from wechat_formatter import format_article

# 转换 Markdown 为公众号 HTML
html = format_article(
    markdown_content="# 标题\n\n正文内容...",
    style_version="v2.0",  # 或 "v1.0" 使用旧版
    author_info={
        "name": "徐沛霖",
        "title": "雨后甘霖创始人",
        "avatar": "徐"
    }
)
```

## Features

- ✅ 自动转换 Markdown 为微信公众号 HTML
- ✅ 支持雨后甘霖 v1.0 和 v2.0 两种排版风格
- ✅ 自动添加作者简介和标签
- ✅ 支持视频号导流占位
- ✅ 支持相关文章推荐
- ✅ 移动端适配

## Output Example

输入 Markdown:
```markdown
# 文章标题

正文段落，**重点文字**。

## 章节标题

- 列表项1
- 列表项2

> 引用内容
```

输出 HTML:
```html
<!DOCTYPE html>
<html>
<head>...</head>
<body>
    <div class="article-container">
        <h1>文章标题</h1>
        <p>正文段落，<strong>重点文字</strong>。</p>
        <h2>章节标题</h2>
        <ul>...</ul>
        <blockquote>...</blockquote>
    </div>
</body>
</html>
```
