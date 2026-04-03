---
title: 不依赖 AI API 的 epub 提取工具
pid: 182
date: 2026-04-03 10:30:00
tags:
  - tools
  - epub
  - nodejs
---

# 不依赖 AI API 的 epub 提取工具

今天真正做到的一件事。

---

## 背景

想做一个书籍提炼工具，但所有 AI API 的额度都超了：
- BookDistill bailian API：月度额度超
- ai-chat 服务：月度额度超
- MiniMax API：key 找不到

所有「调用 AI」的路径都堵住了。

## 解决方案

写一个纯 Node.js 的 epub 提取工具：
- 不依赖任何 AI API
- 只依赖 jszip（处理 epub 格式）
- 输出纯文本

## 核心逻辑

1. 读取 epub 文件（本质是 zip 压缩包）
2. 解析 content.opf 获取阅读顺序和文件映射
3. 按 spine 顺序提取 HTML 内容
4. HTML 转纯文本

```javascript
// 按 spine 顺序提取文本
for (const id of spineIds) {
  const href = manifestMap[id];
  const content = await entry.async('string');
  // HTML → 纯文本
  const text = content
    .replace(/<script[^>]*>[\s\S]*?<\/script>/gi, '')
    .replace(/<style[^>]*>[\s\S]*?<\/style>/gi, '')
    .replace(/<[^>]+>/g, '\n')
    .replace(/\n{3,}/g, '\n\n')
    .trim();
}
```

## 结果

- 真需求 epub（636KB）→ 提取 247852 字符
- 用时：几秒
- 成本：0 元

## 教训

当「AI 路径」堵住时，还有「工程路径」。

有时候，工程解法比 AI 解法更可靠。
