# RC0 产品需求 · 内容 · 关于 · 范围与能力总览

> 版本：v0.1（基于代码与 GitHub 现状整理）  
> 仓库：[`qianNya/rc0-flutter`](https://github.com/qianNya/rc0-flutter)  
> 关联前身：[`qianNya/rc0`](https://github.com/qianNya/rc0)（本地剧本 / 姿势参考）  
> 参考 PR：[#1 docs: add ten RC0 art and internet-venture skills](https://github.com/qianNya/rc0-flutter/pull/1)  
> 平台现状：iOS `TARGETED_DEVICE_FAMILY = 1,2`（iPhone + **iPad**），App 显示名 `Rc0 Flutter`

---

## 0. 一页纸总结（先看这里）

| 项 | 结论 |
|---|---|
| **产品是什么** | 面向互联网短剧 / 分镜 / 摄影预设的创作与分发 App：发现作品 → 用向导创作 → 发布为模板 / 画廊 → 社交互动 |
| **核心对象树** | 剧本 → 幕 → 场 → 镜（帧），帧绑定摄影预设 / 色彩 LUT |
| **主入口（底栏）** | 首页 · 图库 · 创建(+) · 消息 · 我的 |
| **创作仪式** | 基本信息 → 结构 → 画面 → 参数 → 角色 → 发布（本地 / 云端） |
| **内容域** | 信息流、模板市场、剧本详情、帧查看器、画廊静帧、电影预设、创作者主页、通知 |
| **关于域（缺口）** | 设置里尚无「关于 RC0 / 版本 / 许可 / 隐私政策」正式页；需补齐产品身份与合规入口 |
| **iPad 现状** | 工程已允许 iPad 安装与多方向；布局仍偏手机底栏，未做平板分栏 / 侧栏自适应 |
| **架构** | Feature First + Clean Architecture + Riverpod + go_router |
| **本文用途** | 统一「需求 / 内容 / 关于」范围识别格式，供设计、研发、Agent 对齐 |

---

## 1. 产品定位

### 1.1 一句话

**RC0** 是把「短剧编剧 + 分镜连环画 + 电影摄影语言」落到可编辑、可发布、可在信息流分发的互联网创作产品。

### 1.2 从 rc0 → rc0-flutter 的演进

| 维度 | 旧 `rc0` | 当前 `rc0-flutter` |
|---|---|---|
| 核心 | 本地剧本（姿势参考）管理 | 云端同步 + 模板市场 + 社交信息流 |
| 结构 | Screenplay / Act / Scene / Frame | 同构，扩展 Draft、CinePreset、Feed、Template |
| Shell | 移动底栏 + 桌面侧栏自适应 | 目前仅底栏五 Tab（手机优先） |
| 创作 | 上传 / 分层编辑器 | 六步创建向导 + 草稿同步 |
| 分发 | 发现 / Fork / 收藏 | 发现·关注·推荐·社区 + 模板商品化 |

### 1.3 目标用户（假设，待确认）

| 角色 ID | 角色 | 主要目标 |
|---|---|---|
| `AU-creator` | 短剧 / 分镜创作者 | 快速搭幕场镜、生成画面、发布模板 |
| `AU-buyer` | 模板使用者 / 二创者 | 浏览热门模板、套用预设、开新草稿 |
| `AU-viewer` | 观众 / 社区用户 | 在信息流看作品、点赞评论收藏、关注作者 |
| `AU-ip` | IP / 系列作者 | 连载、署名、色彩与画幅身份一致 |

---

## 2. 范围识别格式（Scope ID）

后续所有需求、内容、关于项统一使用下列格式，便于追踪与裁剪。

### 2.1 编号规则

```
SCOPE-<域>-<序号>
REQ-<域>-<序号>
CAP-<域>-<序号>
GAP-<域>-<序号>
Q-DESIGN-<序号>
```

| 前缀 | 含义 |
|---|---|
| `SCOPE` | 产品范围边界（做什么 / 不做什么） |
| `REQ` | 可验收的功能需求 |
| `CAP` | 已具备或目标能力描述 |
| `GAP` | 代码或产品上的缺口 |
| `Q-DESIGN` | 待产品 / 设计确认的问题 |

| 域代码 | 中文 | 说明 |
|---|---|---|
| `PRD` | 产品总览 | 定位、平台、非功能 |
| `NAV` | 导航与壳 | 底栏、路由、深链 |
| `FEED` | 内容·信息流 | 发现/关注/推荐/社区 |
| `MKT` | 内容·模板市场 | 封面商品、详情试读 |
| `CRT` | 内容·创作 | 向导、草稿、生成、发布 |
| `SCR` | 内容·剧本/分镜 | 详情、帧查看器 |
| `GAL` | 内容·画廊 | 静帧展览 |
| `PRE` | 内容·预设 | 摄影 / LUT |
| `SOC` | 内容·社交 | 消息、关注、互动 |
| `PRF` | 内容·个人 | 主页、作品集 |
| `AUTH` | 账户 | 登录注册安全 |
| `SET` | 设置 | 外观、通知、存储 |
| `ABT` | 关于 | 品牌、版本、合规、能力说明 |
| `IPD` | iPad / 平板 | 大屏布局与交互 |
| `ART` | 艺术领域技能 | 与 PR #1 十份 skills 对齐 |

### 2.2 单条范围条目模板

```markdown
### SCOPE-XXX-001 — 标题

| 字段 | 值 |
|---|---|
| 状态 | In / Out / Partial |
| 优先级 | P0 / P1 / P2 |
| 用户 | AU-* |
| 能力 | CAP-*-* |
| 依赖 | 路由 / API / 实体 |
| 验收 | 可观察行为 |
| 备注 | iPad / 合规 / 风险 |
```

---

## 3. SCOPE 总表（范围边界）

### 3.1 In Scope（当前产品应覆盖）

| Scope ID | 状态 | 说明 |
|---|---|---|
| `SCOPE-PRD-001` | In | Flutter 跨端客户端：iOS（含 iPad）、Android；工程另含 web/desktop 目录 |
| `SCOPE-NAV-001` | In | 五 Tab Shell：首页 / 图库 / 创建 / 消息 / 我的 |
| `SCOPE-FEED-001` | In | 首页四流：发现、关注、推荐、社区 |
| `SCOPE-MKT-001` | In | 模板轮播、热门模板、模板详情（幕/场试读）、徽章 hot/new |
| `SCOPE-CRT-001` | In | 创建向导六步 + 草稿本地/云发布 |
| `SCOPE-SCR-001` | In | 剧本详情、场内帧查看器（深链含 sceneId / frameIndex） |
| `SCOPE-GAL-001` | In | 图库静帧网格与分辨率/标签信息 |
| `SCOPE-PRE-001` | In | 电影预设列表与详情（画幅、帧率、色彩、LUT） |
| `SCOPE-SOC-001` | In | 消息通知：评论 / 点赞 / 收藏 |
| `SCOPE-PRF-001` | Partial | 个人主页、作品集、菜单入口；部分菜单未接线 |
| `SCOPE-AUTH-001` | In | 登录 / 注册 / Guest；Token 走 secure storage |
| `SCOPE-SET-001` | Partial | 主题模式、账户入口、占位通知与缓存 |
| `SCOPE-ART-001` | In（文档层） | 十份艺术 × 互联网创业 Agent Skills（PR #1） |

### 3.2 Out of Scope（明确不做或暂不做）

| Scope ID | 说明 |
|---|---|
| `SCOPE-PRD-OUT-001` | 完整视频剪辑时间线（非帧序列工具） |
| `SCOPE-PRD-OUT-002` | 站内支付收银台完整实现（向导不催充值） |
| `SCOPE-PRD-OUT-003` | 把第三方 LUT 文件 / 模型密钥写入仓库或草稿实体 |
| `SCOPE-FEED-OUT-001` | 信息流默认跳转外部商城 / 私信导流 |
| `SCOPE-ABT-OUT-001` | 在客户端硬编码长篇版权条款全文（只展示作者、来源、是否允许模板） |

### 3.3 Partial / Gap（已知缺口）

| Gap ID | 关联 | 现象 |
|---|---|---|
| `GAP-PRF-001` | 我的 | 「我的收藏 / 浏览历史 / 下载管理」菜单无路由 |
| `GAP-SET-001` | 设置 | 「账户与安全 / 隐私」无实质页；无「关于」区块 |
| `GAP-ABT-001` | 关于 | README 仍是 Flutter 默认模板，缺少产品介绍 |
| `GAP-IPD-001` | iPad | 可安装，但无 `adaptive` 侧栏 / 双栏；底栏在大屏浪费横向空间 |
| `GAP-CRT-001` | 创作 | AIGC 生成与后端成本反馈体验未产品化说明 |
| `GAP-SOC-001` | 社交 | 关注关系、评论写入链路完整度需对照后端 |

---

## 4. 内容域需求与能力（REQ / CAP）

### 4.1 导航与信息架构

| ID | 类型 | 内容 | 优先级 |
|---|---|---|---|
| `REQ-NAV-001` | REQ | 底栏五入口稳定可达，创建为中心强调按钮 | P0 |
| `REQ-NAV-002` | REQ | 旧路由 `/explore` `/community` `/favorites` 重定向到新 IA | P0 |
| `REQ-NAV-003` | REQ | 深链：`/template/:id`、`/screenplay/:id/scene/:sceneId/frame/:i`、`/create/:draftId` | P0 |
| `CAP-NAV-001` | CAP | go_router + StatefulShellRoute.indexedStack | — |

首页快捷入口（内容门类，不是同一种商品卡）：

| 入口 | 路由 | 内容类型 |
|---|---|---|
| 图片 | `/gallery` | 画廊静帧 |
| 剧本 | `/scripts` | 剧本列表 |
| 分镜 | `/storyboards` | 分镜列表 |
| 预设 | `/presets` | 摄影预设 |
| 用户 | `/users` | 创作者发现 |

### 4.2 信息流（FEED）

| ID | 说明 | 优先级 |
|---|---|---|
| `REQ-FEED-001` | 四 Tab 策展理由不同：发现=作品第一格；关注=作者时间线；推荐=类型差异；社区=讨论优先 | P0 |
| `REQ-FEED-002` | `FeedItem` 展示标题、封面、作者、赞评、标签；封面取转折格 | P0 |
| `REQ-FEED-003` | 空态说明原因并给出回到作品的入口，禁止假数据刷屏 | P1 |
| `CAP-FEED-001` | explore / home tabs + FeedItem 实体 | — |

### 4.3 模板市场（MKT）

| ID | 说明 | 优先级 |
|---|---|---|
| `REQ-MKT-001` | 轮播仅放有封面、作者、结构的模板 | P0 |
| `REQ-MKT-002` | 徽章仅 `hot` / `newItem`，不叠加第三种 | P1 |
| `REQ-MKT-003` | 详情提供幕/场试读目录与 frameCount | P0 |
| `CAP-MKT-001` | TemplateItem / TemplateDetail / ActItem / SceneItem | — |

### 4.4 创作向导（CRT）

| 步骤 | 名称 | 需求要点 |
|---|---|---|
| 1 | 基本信息 | 标题等元信息；不问滤镜/价格 |
| 2 | 结构 | 幕 / 场 / 一句冲突描述（`WizardAct` / `WizardScene`） |
| 3 | 画面 | 生成结果 → 帧资产引用；作者确认后才算完成 |
| 4 | 参数 | 摄影 / 画幅等参数 |
| 5 | 角色 | 角色信息 |
| 6 | 发布 | 确认标题、封面格、预设、场目录；本地或云端发布 |

| ID | 说明 | 优先级 |
|---|---|---|
| `REQ-CRT-001` | 生成失败保留已写结构，不回退命名 | P0 |
| `REQ-CRT-002` | 未发布草稿不进发现流 / 模板市场 | P0 |
| `REQ-CRT-003` | 密钥与模型 token 不进实体、日志、界面 | P0 |
| `CAP-CRT-001` | create_wizard + screenplay_draft（manifest / sync / assets） | — |

### 4.5 剧本 · 分镜 · 帧（SCR）

核心内容模型：

```
DraftScreenplay
 └─ DraftAct
     └─ DraftScene
         └─ DraftFrame  (dialogue, actionNote, shotType, durationSec,
                         cinePresetId, imageAssetRef, ...)
```

| ID | 说明 | 优先级 |
|---|---|---|
| `REQ-SCR-001` | 一场是最小可分发 / 可封面化单元 | P0 |
| `REQ-SCR-002` | 默认单镜 `durationSec=3`，默认景别 `medium` | P1 |
| `REQ-SCR-003` | 帧查看器按场进入，深链落到有事件的格 | P0 |
| `CAP-SCR-001` | screenplay_detail + frame_viewer + draft 树 | — |

### 4.6 画廊（GAL）

| ID | 说明 | 优先级 |
|---|---|---|
| `REQ-GAL-001` | 按原始宽高比陈列，禁止拉伸 | P0 |
| `REQ-GAL-002` | 草稿缩略图不自动进公开画廊 | P0 |
| `CAP-GAL-001` | GalleryImage（url / w / h / resolution / tag） | — |

### 4.7 预设与色彩（PRE）

| ID | 说明 | 优先级 |
|---|---|---|
| `REQ-PRE-001` | 预设承载 aspectRatio、frameRate、colorSpace、lut | P0 |
| `REQ-PRE-002` | 帧只存 `cinePresetId`，不每镜发明滤镜名 | P0 |
| `CAP-PRE-001` | CinePresetItem / CinePresetDetail | — |

### 4.8 社交与个人（SOC / PRF）

| ID | 说明 | 优先级 |
|---|---|---|
| `REQ-SOC-001` | 通知类型：comment / like / favorite | P0 |
| `REQ-PRF-001` | 主页展示 bio、封面、等级、作品网格与计数一致 | P0 |
| `REQ-PRF-002` | Guest 提示登录以同步剧本、预设与收藏 | P0 |
| `GAP-PRF-001` | 收藏 / 历史 / 下载菜单待接线 | P1 |

### 4.9 账户与安全（AUTH）

| ID | 说明 | 优先级 |
|---|---|---|
| `REQ-AUTH-001` | 登录 / 注册；已登录不可停留在 auth 页 | P0 |
| `REQ-AUTH-002` | Token 仅 `flutter_secure_storage`，经 interceptor 注入 | P0 |
| `CAP-AUTH-001` | AuthSession / AuthTokens / AuthUser | — |

---

## 5. 「关于」范围与能力（ABT）

「关于」不是设置里的一个死链，而是**产品身份 + 合规 + 能力边界**的对外说明面。

### 5.1 关于应包含的能力清单

| ID | 状态 | 内容项 | 说明 |
|---|---|---|---|
| `REQ-ABT-001` | Gap | 产品名称与一句话定位 | 建议：「RC0 — 短剧分镜创作与分发」 |
| `REQ-ABT-002` | Gap | 版本号 / Build | 对齐 `pubspec` `1.0.0+1` 与 iOS CFBundle |
| `REQ-ABT-003` | Gap | 平台能力说明 | iPhone / iPad / Android；可选桌面 Web |
| `REQ-ABT-004` | Gap | 核心能力摘要 | 创作树、模板市场、信息流、预设、画廊 |
| `REQ-ABT-005` | Gap | 隐私政策 / 用户协议入口 | 设置或关于页外链 |
| `REQ-ABT-006` | Gap | 开源与第三方致谢 | Flutter / 依赖列表摘要 |
| `REQ-ABT-007` | Gap | 联系与反馈 | 与消息域区分：客服 / 反馈渠道 |
| `CAP-ABT-001` | Partial | 设置页已有账户、外观、通知、存储；缺关于区块 | — |

### 5.2 关于页信息架构（建议）

```
设置
 └─ 关于 RC0
     ├─ Logo + 产品名 + 版本
     ├─ 我们做什么（3 条能力）
     ├─ 支持的设备（含 iPad）
     ├─ 隐私政策 · 用户协议
     └─ 开源许可 / 反馈
```

### 5.3 产品能力矩阵（给「关于 / 官网 / README」复用）

| 能力面 | 用户能做什么 | 对应模块 |
|---|---|---|
| 发现 | 四流浏览作品与模板 | home / explore / template_market |
| 创作 | 六步向导生成幕场镜草稿 | create_wizard / screenplay_draft |
| 精修 | 景别、运镜、焦段、画幅、LUT | cine_preset / draft frame |
| 展览 | 静帧画廊按比例观看 | gallery |
| 商品化 | 模板封面、徽章、试读目录 | template_detail |
| 社交 | 赞评藏通知、关注作者 | messages / profile |
| 身份 | 登录同步剧本与预设 | auth |

---

## 6. iPad 使用范围（IPD）

工程侧已具备：

- `TARGETED_DEVICE_FAMILY = "1,2"`
- `UISupportedInterfaceOrientations~ipad` 四方向
- App Icon 含 iPad idiom

产品侧建议范围：

| ID | 优先级 | 需求 |
|---|---|---|
| `REQ-IPD-001` | P0 | iPad 可安装运行，无崩溃；竖/横可用 |
| `REQ-IPD-002` | P1 | 大屏：首页 / 图库 / 模板详情采用双栏（列表 + 详情） |
| `REQ-IPD-003` | P1 | 创建向导在横屏用更宽步骤区，进度条不挤压文案 |
| `REQ-IPD-004` | P1 | 帧查看器利用宽屏并排缩略图条 + 大图 |
| `REQ-IPD-005` | P2 | 可选：侧栏导航替代底栏（对齐旧 rc0 `adaptive_shell`） |
| `REQ-IPD-006` | P2 | 键盘 / 触控板：列表焦点与快捷键（← → 切帧） |
| `GAP-IPD-001` | — | 当前 UI 未做 `shortestSide` / breakpoint 自适应 |

**iPad 内容体验原则（从艺术技能继承）**

- 竖屏 9:16 作品在横屏 iPad 上：画面居中 + 侧旁信息，不硬拉变形。  
- 画廊尊重原比例。  
- 模板封面与信息流卡片在更大栅格下仍保持「一屏可区分」的策展节奏。

---

## 7. 艺术领域能力映射（与 GitHub PR #1）

| Skill | 艺术域 | 接到的产品对象 |
|---|---|---|
| `rc0-short-drama-writing` | 短剧编剧 | 幕/场/对白/动作提示 |
| `rc0-storyboard-sequential-art` | 分镜连环画 | 帧序、时长、缩略图 |
| `rc0-cinematography-language` | 电影摄影 | 景别、运镜、焦段、画幅、帧率 |
| `rc0-color-lut-identity` | 色彩 LUT | colorSpace、lut、预设 id |
| `rc0-template-cover-commerce` | 封面商品 | 模板卡、徽章、试读 |
| `rc0-gallery-exhibition` | 数字画廊 | 静帧比例、分辨率、标签 |
| `rc0-feed-curation-art` | 信息流策展 | 发现/关注/推荐/社区 |
| `rc0-creator-persona-art` | 创作者人格 | 主页、简介、互动回声 |
| `rc0-generative-creation-ritual` | 生成仪式 | 向导与草稿发布 |
| `rc0-serial-ip-adaptation` | 连载 IP | 来源署名、预设继承 |

---

## 8. 非功能需求

| ID | 类别 | 要求 |
|---|---|---|
| `REQ-PRD-NFR-001` | 架构 | Feature First；UI → Provider → UseCase → Repository → Datasource |
| `REQ-PRD-NFR-002` | 性能 | 长列表 builder；图片缓存；build 内无网络/重计算 |
| `REQ-PRD-NFR-003` | 安全 | 无明文 Token/密钥；secure storage + auth interceptor |
| `REQ-PRD-NFR-004` | 主题 | 跟随系统 / 浅色 / 深色；token 化颜色与间距 |
| `REQ-PRD-NFR-005` | 网络 | Dio；`API_BASE_URL` 可 dart-define 覆盖 |

---

## 9. 文档总结项（Checklist）

可用于评审勾选：

- [ ] **定位**：RC0 = 短剧分镜创作与互联网分发（已对齐代码与 skills）
- [ ] **内容树**：剧本 → 幕 → 场 → 镜 + 预设
- [ ] **主路径**：发现 → 详情/试读 → 创建向导 → 发布 → 主页作品集
- [ ] **五 Tab IA** 与快捷入口五门类
- [ ] **关于**：产品名、版本、能力、合规入口（待实现）
- [ ] **iPad**：能装能用（已具备）/ 大屏体验（待设计）
- [ ] **Out of Scope**：非剪辑时间线、无密钥入库、无假热度
- [ ] **Gaps**：收藏/历史/下载、关于页、平板自适应
- [ ] **设计问题**：见第 10 节，需产品拍板后升 REQ

---

## 10. 应用设计提问清单（请回复编号）

请按编号回复，答案将回填为正式 `REQ-*`。

### 品牌与关于

1. `Q-DESIGN-001` 对外正式产品名是 **RC0**、**Rc0**、还是中文名？iOS 显示名是否从 `Rc0 Flutter` 改为品牌名？  
2. `Q-DESIGN-002` 「关于」页要不要放品牌故事 / Slogan？一句话是什么？  
3. `Q-DESIGN-003` 隐私政策与用户协议是外链 H5，还是应用内 Markdown？

### 信息架构与视觉

4. `Q-DESIGN-004` iPad 优先：**保持底栏** 还是 **侧栏导航**（类似旧 rc0 adaptive shell）？  
5. `Q-DESIGN-005` 首页第一视界：搜索 + 四 Tab + 轮播 + 快捷入口，是否过密？iPad 是否把轮播与快捷入口拆到次屏？  
6. `Q-DESIGN-006` 默认主题偏向深色（当前设置默认倾向）还是浅色创作向导的「仪式感」双主题并存即可？

### 内容与创作

7. `Q-DESIGN-007` 创建向导六步顺序是否固定？是否允许「从模板二创」跳过基本信息？  
8. `Q-DESIGN-008` 竖屏短剧（9:16）是否为默认画幅？横屏 16:9 / 2.39:1 是否仅高级选项？  
9. `Q-DESIGN-009` 模板市场的商业化程度：仅展示社交证明，还是要价格 / 授权标签？  
10. `Q-DESIGN-010` 图库与「作品分镜」边界：用户是否需要一键「从帧发布到画廊」？

### iPad 专项

11. `Q-DESIGN-011` 帧查看器在 iPad 横屏是否必须左右分栏（缩略图 | 大图 | 对白）？  
12. `Q-DESIGN-012` 是否支持 Stage Manager / 分屏最小宽度布局？最低适配哪一代 iPad？  
13. `Q-DESIGN-013` Apple Pencil：是否纳入 v1（批注分镜），还是明确 Out of Scope？

### 社交与个人

14. `Q-DESIGN-014` 「我的收藏 / 浏览历史 / 下载管理」哪些进 P0？  
15. `Q-DESIGN-015` 创作者等级展示规则是否已有平台口径？主页是否展示粉丝列表？

---

## 11. 建议落地顺序（工程）

| 阶段 | 交付 | Scope |
|---|---|---|
| A | 补齐 README + 关于页文案与设置入口 | `REQ-ABT-*`、`GAP-ABT-001` |
| B | 接线收藏等个人菜单或隐藏未完成入口 | `GAP-PRF-001` |
| C | iPad breakpoint：双栏详情 / 向导宽布局 | `REQ-IPD-002~004` |
| D | 合并 PR #1 skills，作为 Agent 创作规范 | `SCOPE-ART-001` |
| E | 按设计问答结果改 IA 与默认画幅 | `Q-DESIGN-*` → `REQ-*` |

---

## 12. 来源索引

| 来源 | 用途 |
|---|---|
| `lib/features/*` | 功能模块与实体真相 |
| `lib/app/router/*` | 路由与 IA |
| `ios/Runner/*`、`project.pbxproj` | iPad 设备族与方向 |
| GitHub PR #1 | 十域艺术 × 互联网创业能力 |
| `qianNya/rc0` README | 前身领域模型与自适应壳参考 |

---

*本文档为产品范围识别基线。回答第 10 节问题后，应更新版本号并将会答项升级为正式需求。*
