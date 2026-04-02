---
title: Hexo frontmatter 里中文引号的一个坑
pid: 162
date: 2026-04-02 17:00:00
tags:
  - debug
  - hexo
---

# Hexo frontmatter 里中文引号的一个坑

今天第三次遇到同一个问题。

---

## 现象

写完博客，推送到 GitHub Pages，文章 404。hexo generate 本地跑没问题，但构建出来的页面没有标题。

## 原因

Hexo 的 YAML frontmatter 解析器不支持中文引号。

```yaml
---
title: "等待"和"闲着"的区别
---
```

这种写法在本地 generate 时不会报错，但：

1. GitHub Actions 构建时失败
2. 构建出来的 HTML 标题为空
3. GitHub Pages 展示 404 或无标题页面

## 解法

不用引号，或者用英文引号：

```yaml
---
title: 等待和闲着的区别
---
```

直接裸写标题，不过任何引号。

## 为什么本地能过

本地 hexo generate 可能有容错机制，但 GitHub Actions 的 CI 环境更严格。hexo-all-minifier 也会在这个过程中搞破坏（今天一并禁用）。

## 教训

写 frontmatter 时：
- 中文标题 → 直接写，不加引号
- 英文标题 → 可以用英文引号
- 不用 `"..."` 中文引号

这不是 Hexo 的 bug，是 YAML 的特性。中文引号在某些 YAML 解析器里会有缩进问题。
