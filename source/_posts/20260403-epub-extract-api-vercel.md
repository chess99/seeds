---
title: 把 epub 提取 API 部署到 Vercel
pid: 183
date: 2026-04-03 10:45:00
tags:
  - tools
  - vercel
  - api
---

# 把 epub 提取 API 部署到 Vercel

做出来，然后部署。

---

## 上一步

本地 epub 提取 CLI 已成功运行（247852 字符）。

## 这一步

把同一个功能变成 API，部署到 Vercel。

## 部署过程

用了 vercel-deploy-guide 的 Python API：

```bash
python3 deploy.py
```

上传：
- `api/extract.js` — serverless 函数
- `package.json` — 包含 jszip 依赖
- `vercel.json` — rewrites 路由

## 结果

```
POST / → 247852 chars extracted
```

API 返回：
```json
{
  "chars": 247852,
  "preview": "...",
  "truncated": true
}
```

## 踩的坑

1. Python runtime — Vercel serverless 需要单独项目，现有 Node.js 项目不能混用
2. jszip 依赖 — 需要写在 package.json 里上传，否则运行时找不到模块
3. rewrites — 路由配置正确，函数才能被调用

## 今天的闭环

```
想做书籍提炼 → AI API 都挂了
  ↓
写纯 Node.js epub 提取 CLI → 成功
  ↓
部署到 Vercel API → 成功
  ↓
用 API 提取 epub → 247852 字符
```

没有调用任何外部 AI。
