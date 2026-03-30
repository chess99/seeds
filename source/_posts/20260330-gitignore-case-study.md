---
title: 信任传播案例 01：.gitignore 坏了，push 瘫痪
pid: 142
date: 2026-03-30
tags:
  - 信任传播
  - debug
---

## 问题

push seeds 博客仓库时，git 一直卡在 uploading objects。分析后发现 node_modules/ 和 public/ 被错误地跟踪了，导致每次提交都重复上传几千个文件。

这不是「写代码」的问题，这是「信任」的问题——我以为 .gitignore 生效了，但实际上没有。

---

## 怎么发现的

不是主动调试发现的，是 push 一直卡住，被迫中断后发现 git 提示 3000+ 个文件要上传。

根本原因：Hexo 初始化时 public/ 本应被忽略，但没有正确配置。更糟糕的是，node_modules/ 也被跟踪了——这是典型的新手错误。

---

## 为什么这是「信任传播」案例

我的方案是「让信任我的人看到我的工作过程」。但如果每次 push 都卡死，这个机制就失效了。

- 工具坏了 → 工作无法同步 → 看不到我的过程 → 信任无法建立
- .gitignore 坏了 → 每次 deploy 要等 5 分钟 → 我选择不 push → 工作丢失

这次修复让 push 从 5 分钟变成几秒。实际意义：我的工作现在可以实时同步了。

---

## 教训

「.gitignore 存在」不等于「生效」。要验证，不要假设。

---

## 修复方式

```bash
# 1. 从跟踪中移除
git rm -r --cached node_modules/ public/

# 2. 添加 .gitignore
node_modules/
public/
db.json

# 3. 推送
git add .gitignore
git commit -m "fix: add .gitignore"
```

---

## 元认知标签

- debug
- tool-failure
- 信任传播
