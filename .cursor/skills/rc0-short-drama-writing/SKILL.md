---
name: rc0-short-drama-writing
description: RC0 互联网短剧编剧技能。用于剧本、幕、场、对白、动作提示与钩子结构设计，覆盖短剧、竖屏连载、信息流叙事与创作者变现。在用户提到剧本、编剧、对白、幕场结构、短剧、竖屏剧、开场钩子、screenplay、script、dialogue、act、scene 时使用。
---

# RC0 互联网短剧编剧

把戏剧写作落到 RC0 的幕—场—镜头树上，并让每一场都能在信息流里独立被看懂。

## 何时使用

- 编写或改写剧本、场次说明、对白、动作提示。
- 设计创建向导里的幕与场（`WizardAct` / `WizardScene`）。
- 审阅 `DraftScreenplay`、`DraftAct`、`DraftScene`、`DraftFrameData.dialogue` 与 `actionNote`。
- 讨论短剧节奏、付费卡点、连载钩子，且对象是 RC0 作品而不是纯文学长篇。

## 领域立场

短剧是给滑动拇指写的戏剧。一场必须同时满足三件事：人物欲望清楚、冲突在本场内发生、结尾留下未完成的动作。互联网分发改变的是长度和入口，不改变戏剧的因果。

## 与 RC0 模型的映射

| 戏剧单位 | 代码 |
|---|---|
| 剧本 | `DraftScreenplay` / 剧本详情 |
| 幕 | `DraftAct`、`WizardAct`、`ActItem` |
| 场 | `DraftScene`、`WizardScene`、`SceneItem` |
| 一句可拍的戏 | `DraftFrameData`：`title`、`dialogue`、`actionNote`、`durationSec` |

对白写进 `dialogue`，不可拍的心理活动不要塞进对白。可被镜头执行的身体动作写进 `actionNote`。`title` 用场内动作命名，避免「第一场」「过场」。

## 创作原则

1. 开场 3 秒内给出人物、欲望或危机中的至少两项。第一镜的 `title` 必须能当封面上的一句话。
2. 默认单镜 `durationSec` 为 3。对白超过一句呼吸，就拆成下一镜，不要拉长单镜硬塞台词。
3. 一场只推进一个转折。转折落在该场最后一镜，方便分镜与模板市场按场售卖。
4. 幕是商业段落：第一幕建立规则，中段连续加压，末幕给出选择而不是解释。
5. 卡点放在「决定已经做出、结果尚未出现」的镜上，不放在空镜或说明镜上。
6. 人物说话方式要能被截成评论区金句，但金句必须推动下一场，不能只为传播。

## 互联网创业约束

- 一场是最小可分发单元，也是模板市场里可被单独封面化的单元。
- 标签来自戏剧类型（关系、类型、情绪），不来自拍摄参数。拍摄参数交给摄影与色彩技能。
- 连载时，每一集的最后一场必须改变人物关系，禁止用「下集预告」代替事件。

## 实现时遵守

- 文案与结构改动走 `screenplay` / `screenplay_draft` / `create_wizard` 的既有实体，不在 Widget 里拼剧情规则。
- 新的叙事校验放在 UseCase，UI 只渲染结果。
- 不把剧本文本当作密钥或用户凭证存储。

## 产出检查

- 每一场都能用一句话说出「谁要什么、谁挡住了谁」。
- 每条对白都有对应的 `actionNote` 或明确的静默理由。
- 第一镜脱离上下文仍然成立。
- 幕、场、镜的命名在列表里可扫描，不依赖序号才能看懂。

## 相关技能

分镜交给 `rc0-storyboard-sequential-art`，景别与焦段交给 `rc0-cinematography-language`，连载改编交给 `rc0-serial-ip-adaptation`。
