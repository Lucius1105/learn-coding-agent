#!/usr/bin/env python3
"""
雨后甘霖公众号排版格式化工具
支持 v1.0 和 v2.0 (Inkflow升级版) 两种风格
"""

import re
import markdown
from datetime import datetime


class WeChatFormatter:
    """微信公众号文章格式化器"""
    
    # 雨后甘霖品牌色彩系统
    COLORS = {
        "v1.0": {
            "wisdom_blue_deep": "#0D1A63",
            "wisdom_blue": "#060E9F",
            "harvest_gold": "#FFB547",
            "dark_grey": "#414042",
            "air_white": "#FFFFFF",
            "quote_bg": "#F5F7FA",
            "divider": "#E8EBF0",
            "light_blue": "#E8F0FF",
        },
        "v2.0": {
            "ink_black": "#1A1A1A",
            "ink_deep": "#2D1E1B",
            "cream_white": "#F5F5F0",
            "cream_light": "#FAFAF8",
            "harvest_gold": "#C9A227",
            "harvest_light": "rgba(201, 162, 39, 0.12)",
            "text_primary": "#2D2D2D",
            "text_secondary": "rgba(45, 45, 45, 0.65)",
            "text_tertiary": "rgba(45, 45, 45, 0.4)",
            "divider": "rgba(45, 45, 45, 0.08)",
            "divider_strong": "rgba(45, 45, 45, 0.15)",
        }
    }
    
    def __init__(self, version="v2.0"):
        """
        初始化格式化器
        
        Args:
            version: 排版版本，"v1.0" 或 "v2.0"
        """
        self.version = version
        self.colors = self.COLORS[version]
        
    def format_article(self, markdown_content, author_info=None, tags=None):
        """
        将 Markdown 转换为微信公众号 HTML
        
        Args:
            markdown_content: Markdown 格式文章内容
            author_info: 作者信息字典，包含 name, title, avatar, desc
            tags: 文章标签列表
            
        Returns:
            str: 完整的 HTML 文档
        """
        # 转换 Markdown 为 HTML
        md = markdown.Markdown(extensions=['extra', 'nl2br'])
        body_content = md.convert(markdown_content)
        
        # 应用排版样式
        body_content = self._apply_styles(body_content)
        
        # 生成完整 HTML
        html = self._generate_full_html(body_content, author_info, tags)
        
        return html
    
    def _apply_styles(self, html_content):
        """应用排版样式"""
        if self.version == "v2.0":
            return self._apply_v2_styles(html_content)
        else:
            return self._apply_v1_styles(html_content)
    
    def _apply_v2_styles(self, html_content):
        """应用 v2.0 Inkflow风格样式"""
        # 添加微标签到 h2
        html_content = re.sub(
            r'<h2>(.*?)</h2>',
            r'<p class="micro-label">CHAPTER</p><h2>\1</h2>',
            html_content
        )
        
        # 转换粗体样式
        html_content = html_content.replace(
            '<strong>',
            f'<strong style="color: {self.colors["ink_black"]}; font-weight: 600;">'
        )
        
        # 转换引用块样式
        html_content = html_content.replace(
            '<blockquote>',
            f'''<blockquote style="
                background: {self.colors["cream_light"]};
                border-left: none;
                padding: 24px 32px;
                margin: 32px 0;
                font-family: 'Noto Serif SC', serif;
                font-style: italic;
                font-size: 15px;
                line-height: 1.9;
                color: {self.colors["text_secondary"]};
                position: relative;
            ">'''
        )
        
        return html_content
    
    def _apply_v1_styles(self, html_content):
        """应用 v1.0 商务风格样式"""
        # 转换粗体样式
        html_content = html_content.replace(
            '<strong>',
            f'<strong style="color: {self.colors["wisdom_blue_deep"]}; font-weight: 600;">'
        )
        
        # 转换引用块样式
        html_content = html_content.replace(
            '<blockquote>',
            f'''<blockquote style="
                background: {self.colors["quote_bg"]};
                border-left: 3px solid {self.colors["wisdom_blue_deep"]};
                padding: 16px 20px;
                margin: 24px 0;
                border-radius: 0 6px 6px 0;
            ">'''
        )
        
        return html_content
    
    def _generate_full_html(self, body_content, author_info, tags):
        """生成完整 HTML 文档"""
        if self.version == "v2.0":
            return self._generate_v2_html(body_content, author_info, tags)
        else:
            return self._generate_v1_html(body_content, author_info, tags)
    
    def _generate_v2_html(self, body_content, author_info, tags):
        """生成 v2.0 HTML"""
        c = self.colors
        
        author_section = ""
        if author_info:
            author_section = f'''
        <!-- 作者简介 -->
        <div style="margin-top: 48px; padding-top: 24px; border-top: 1px solid {c['divider']};">
            <div style="display: flex; align-items: center; margin-bottom: 16px;">
                <div style="width: 48px; height: 48px; border-radius: 50%; background: {c['ink_black']}; 
                            display: flex; align-items: center; justify-content: center; 
                            color: white; font-size: 18px; font-weight: bold; margin-right: 12px;">
                    {author_info.get('avatar', '徐')}
                </div>
                <div>
                    <div style="font-size: 15px; font-weight: 600; color: {c['ink_black']};">
                        {author_info.get('name', '徐沛霖')}
                    </div>
                    <div style="font-size: 13px; color: {c['text_secondary']}; margin-top: 2px;">
                        {author_info.get('title', '雨后甘霖创始人')}
                    </div>
                </div>
            </div>
            <div style="font-size: 13px; color: {c['text_secondary']}; line-height: 1.7;">
                {author_info.get('desc', '连续创业13年，陪跑60+企业主。')}
            </div>
        </div>
            '''
        
        tags_section = ""
        if tags:
            tags_html = ''.join([f'<span style="display: inline-block; background: {c["cream_light"]}; 
                color: {c["text_secondary"]}; font-size: 12px; padding: 4px 10px; 
                border-radius: 4px; margin-right: 6px; margin-bottom: 6px;">#{tag}</span>' 
                for tag in tags])
            tags_section = f'''
        <!-- 标签 -->
        <div style="margin-top: 24px;">
            {tags_html}
        </div>
            '''
        
        return f'''<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>雨后甘霖</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;500;600&family=Noto+Sans+SC:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body style="margin: 0; padding: 0; background: {c['cream_white']};">
    <div style="max-width: 680px; margin: 0 auto; padding: 40px 24px; 
                background: {c['cream_white']}; font-family: 'Noto Sans SC', -apple-system, 'PingFang SC', sans-serif;">
        
        {body_content}
        
        {author_section}
        {tags_section}
        
    </div>
</body>
</html>'''
    
    def _generate_v1_html(self, body_content, author_info, tags):
        """生成 v1.0 HTML"""
        # 类似 v2.0，但使用 v1.0 颜色
        c = self.colors
        # ... (v1.0 实现)
        return self._generate_v2_html(body_content, author_info, tags)  # 简化处理


def format_article(markdown_content, version="v2.0", author_info=None, tags=None):
    """
    便捷函数：一键格式化文章
    
    Args:
        markdown_content: Markdown 文章内容
        version: 版本 "v1.0" 或 "v2.0"
        author_info: 作者信息
        tags: 标签列表
        
    Returns:
        str: 完整 HTML
    """
    formatter = WeChatFormatter(version=version)
    return formatter.format_article(markdown_content, author_info, tags)


# CLI 入口
def main():
    """命令行入口"""
    import argparse
    
    parser = argparse.ArgumentParser(description='雨后甘霖公众号文章格式化工具')
    parser.add_argument('--input', '-i', required=True, help='输入 Markdown 文件路径')
    parser.add_argument('--output', '-o', help='输出 HTML 文件路径')
    parser.add_argument('--version', '-v', default='v2.0', choices=['v1.0', 'v2.0'], 
                        help='排版版本')
    
    args = parser.parse_args()
    
    # 读取输入文件
    with open(args.input, 'r', encoding='utf-8') as f:
        markdown_content = f.read()
    
    # 格式化
    html = format_article(markdown_content, version=args.version)
    
    # 输出
    if args.output:
        with open(args.output, 'w', encoding='utf-8') as f:
            f.write(html)
        print(f"✅ 已生成：{args.output}")
    else:
        print(html)


if __name__ == '__main__':
    main()
