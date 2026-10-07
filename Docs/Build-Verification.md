# Build Verification Notes

This reference project was assembled outside macOS, so Xcode signing and Simulator execution cannot be performed in the generation environment.

Static checks completed before packaging:

- all Swift files parse successfully
- all Info.plist and entitlements files parse successfully
- the Xcode project contains references for every generated target/file ID
- the WidgetKit target is embedded in the main app
- the WidgetKit target supports Small and Medium families
- the main app and widget contain the same App Group entitlement
- the widget publisher writes to App Group UserDefaults and calls `WidgetCenter.reloadTimelines`
- the project includes Core Data related entities, repository abstraction, Use Cases, mock-repository tests, and three extension targets

Required macOS/Xcode verification before submission:

1. Select a developer team that can provision App Groups.
2. Register/select `group.com.zadeelsaddik.SkillSwapA3` or replace it consistently with an available App Group identifier.
3. Build the `SkillSwap` scheme.
4. Run all unit tests.
5. Add both Small and Medium SkillSwap widgets in the Simulator.
6. Create/update requests and offers and verify the widget refreshes.
7. Trigger the notification content extension and Action Extension end-to-end.
