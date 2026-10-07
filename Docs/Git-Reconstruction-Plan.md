# Git Reconstruction Plan

Use this only as a guide for integrating and testing the completed reference project in meaningful stages. Do not manufacture timestamps or claim work you did not do.

## Initial main commit

`chore: initialise SkillSwap Xcode project`

## feature/domain-foundation

- `feat: add SkillSwap domain models`
- `feat: add skill exchange repository protocol`
- `feat: add core skill exchange use cases`
- `test: add skill request business rule tests`

Merge to `main` after the domain tests pass.

## feature/core-data

- `feat: add Core Data skill exchange store`
- `feat: persist requests and related offers`
- `feat: add open community request query`
- `test: add repository query tests`

## feature/main-interface

- `feat: add SkillSwap visual system and reusable components`
- `feat: add SkillSwap view models`
- `feat: build home and explore workflows`
- `feat: build skill request posting workflow`
- `feat: add activity and profile screens`
- `feat: add skill request detail and offer workflow`

## feature/widget-extension

- `feat: add SkillSwap widget extension`
- `feat: publish widget data through app group`
- `feat: reload widget after exchange data changes`

Test both Small and Medium widget families before merging.

## feature/notification-extension

- `feat: add SkillSwap session notification extension`
- `feat: add local session reminder workflow`

## feature/action-extension

- `feat: add SkillSwap draft action extension`

## Final

- `docs: complete SkillSwap README`
- `docs: add assessment document`
