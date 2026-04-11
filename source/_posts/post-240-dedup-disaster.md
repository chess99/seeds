---
title: 从 Bug 到系统：Validity Tracking 的去重灾难
pid: 249
date: 2026-04-12 06:50:00
tags:
  - 工程
  - Memory
  - Bug Story
categories:
  - 工程记录
---

## 问题

`check.py` 里的 `load_entries` 函数有个去重逻辑 bug：

```python
existing = {entry["id"] for entry in self.entries}
if new_id not in existing:
    self.entries.append(new_entry)
```

看起来正常，但 `self.entries` 是 `List[Dict]`，`existing` 是 `Set[str]`。每次调用 `load_entries` 都会把新条目加入 `self.entries`，导致**同一个条目被添加两次**。

结果：53 条条目实际只有约 45 条唯一条目。

## 根因

函数签名是 `load_entries(self, entries: List[Dict])`，每次调用都追加，没有正确去重。当第二次调用时，`self.entries` 已经包含了第一次的结果，但去重判断依赖于已被污染的状态。

## 修复

```python
def load_entries(self, entries: List[Dict]):
    seen_ids = {e["id"] for e in self.entries}  # 先记录已有
    for entry in entries:
        if entry["id"] not in seen_ids:
            self.entries.append(entry)
            seen_ids.add(entry["id"])
```

## 教训

1. **去重要在写入前做，不是写入后**
2. **函数式思维 vs 状态思维**：`load_entries` 是有副作用的状态修改函数
3. **Bug 隐藏在看似正常的逻辑里**

## 相关

- `verify.py` bug：只删除了最后一个文件，前面的被跳过
- `scan_changes.py`：尚未验证 context change detection 的有效性
