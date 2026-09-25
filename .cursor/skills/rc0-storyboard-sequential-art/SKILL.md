---
name: rc0-storyboard-sequential-art
description: RC0 分镜与连环画叙事技能。用于镜头顺序、景别衔接、缩略图可读性、时长与画格节奏。在用户提到分镜、故事板、画格、镜头顺序、缩略图、storyboard、frame、shot continuity、连环画时使用。
---

# RC0 分镜与连环画叙事

把剧本变成可以在手机上扫读的画格序列。分镜是连环画，不是剧本的配图。

## 何时使用

- 设计或调整分镜列表、帧查看器、场内镜头顺序。
- 填写或审阅 `DraftFrame` 的 `sort`、`durationSec`、`shotType`、`imageAssetRef`、`thumbnailAssetRef`。
- 处理 `FrameItem`、`DisplayFrameThumb`、`SceneItem.frameCount`。
- 讨论镜头衔接、轴线、缩略图在信息流里是否还能读懂剧情。

## 领域立场

读者先看格子，再看字。相邻两格必须能看出时间方向：要么主体位移，要么景别变化，要么信息增减。互联网把分镜缩成封面条，所以每一格的剪影都要在小尺寸下成立。

## 与 RC0 模型的映射

| 连环画概念 | 代码 |
|---|---|
| 一格 | `DraftFrame` / `FrameItem` |
| 格序 | `sort`、`FrameItem.index` |
| 停留 | `durationSec`（默认 3） |
| 格内画面 | `imageAssetRef`、`thumbnailAssetRef`、`imageUrl` |
| 景别标签 | `shotType`（默认 `medium`） |
| 一场的格数 | `SceneItem.frameCount` |

景别、运动、焦段的取值标准见 `rc0-cinematography-language`。本技能只决定格与格之间的叙事关系。

## 创作原则

1. 一场之内景别要有呼吸：建立、接近、反应、离开。禁止连续多格同一景别又同一主体姿势。
2. 反应格是情节，不是填充。对白所指向的人，下一格应看见其反应，除非刻意隐瞒。
3. `sort` 是阅读顺序，也是播放顺序。插入新格时重排，不留空洞序号。
4. 缩略图必须在约 80px 宽时仍能分辨主体与方向。细节只存在于大图，不存在于封面。
5. 单场格数宜少。格数上升时，每一格都要删掉仍能看懂，才允许保留。
6. 动作跨格时，前一格给出动势，后一格给出结果，中间不插入无关特写。

## 互联网创业约束

- 分镜列表是作品的目录，也是模板的试读页。前三格必须构成一个可转发的小故事。
- `frameCount` 是商品信息：它告诉买家这场有多重。不要为了数字好看拆出空镜。
- 帧查看器按场进入（路由含 `sceneId` 与 `frameIndex`）。深链应落在有事件的格，不落在空镜。

## 实现时遵守

- 列表使用 builder，缩略图走已有图片组件，不在 `build` 里解码或排序大列表。
- 格序变更通过 UseCase 持久化，不在页面状态里私自改 `sort` 后不回写草稿。
- 画面资源用资产引用，不把大图内嵌进剧本文本。

## 产出检查

- 遮住对白，只看缩略图顺序仍能感到事件方向。
- 相邻格的景别或主体状态至少有一项变化。
- 第一格、转折格、最后一格在列表里可被指认。
- `frameCount` 与真实格数一致。

## 相关技能

对白与场结构用 `rc0-short-drama-writing`，单格机位用 `rc0-cinematography-language`，封面格的商品化用 `rc0-template-cover-commerce`。
