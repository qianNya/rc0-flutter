# RC0 Flutter

RC0 — 短剧分镜创作与互联网分发客户端（Flutter）。

把「剧本 → 幕 → 场 → 镜」落到可编辑草稿、模板市场与信息流，并支持摄影预设与画廊静帧。工程已面向 **iPhone + iPad**（`TARGETED_DEVICE_FAMILY = 1,2`）。

## 文档

| 文档 | 说明 |
|---|---|
| [产品需求 · 内容 · 关于 · 范围与能力](docs/PRODUCT_REQUIREMENTS_AND_SCOPE.md) | 范围识别格式、需求/能力/缺口、iPad、关于页、设计提问清单 |

## 主入口

底栏：**首页 · 图库 · 创建 · 消息 · 我的**

创建向导：基本信息 → 结构 → 画面 → 参数 → 角色 → 发布

## 架构

Feature First + Clean Architecture（UI → Provider → UseCase → Repository → Datasource），状态用 Riverpod，路由用 go_router。

## 关联

- 前身仓库：[qianNya/rc0](https://github.com/qianNya/rc0)
- 艺术领域 Skills PR：[#1](https://github.com/qianNya/rc0-flutter/pull/1)

## Getting Started

```bash
flutter pub get
flutter run
```

真机 API 地址可覆盖：

```bash
flutter run --dart-define=API_BASE_URL=http://<LAN_IP>:8080
```
