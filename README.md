# SkillSwap

SkillSwap is an iOS MVP for students and young adults who need practical help but can offer a useful skill in return. Every request contains both sides of the exchange: what the person needs and what they can contribute.

## Domain problem

Small amounts of help such as tutoring, basic repairs, creative support, language practice, or technology assistance are often too minor to justify hiring a professional. At the same time, students and young adults frequently have useful skills they are willing to exchange. SkillSwap models this as a two-sided skill exchange rather than a paid marketplace.

Primary stakeholder: a university student or young adult with limited disposable income who occasionally needs practical help and has skills they can exchange.

## Architecture

The main application follows:

`SwiftUI Views -> ViewModels -> Use Cases -> SkillSwapRepository -> Core Data`

Views and ViewModels never access Core Data directly. `SkillSwapRepository` is a protocol and the unit tests use `TestSkillSwapRepository`.

## Persistence

The app uses Core Data with two related entities:

- `ExchangeRequestEntity`
- `ExchangeOfferEntity`

One request can contain many offers. Deleting a request cascades to its related offers. The open-board query uses predicates for request status, ownership, and optional skill category.

## System extensions

### WidgetKit Widget Extension

The SkillSwap widget exposes useful exchange information on the Home Screen without requiring the user to open the main app. It shows active swaps, pending offers, and the current featured exchange.

It follows the assessment requirements directly:

- reads data from the App Group shared container
- supports `.systemSmall` and `.systemMedium`
- the main app republishes the shared snapshot and calls `WidgetCenter.reloadTimelines` after request or offer data changes

### Notification Content Extension

When a matched exchange produces a local session reminder, the notification content extension replaces the default notification body with a domain-specific SkillSwap view showing the exchange partner and the two sides of the swap.

### SkillSwap Draft Action Extension

An additional Action Extension is included. It accepts selected text or a web URL from a compatible host app and helps turn the context into a two-sided SkillSwap request draft before returning formatted text to the host app.

## App Group

The project is configured with:

`group.com.zadeelsaddik.SkillSwapA3`

Both the main `SkillSwap` target and `SkillSwapWidget` target include the same App Group entitlement.

If this identifier is unavailable on the selected developer team, create a new App Group in Xcode and replace the identifier in:

- `SkillSwap/SkillSwap.entitlements`
- `SkillSwapWidget/SkillSwapWidget.entitlements`
- `SkillSwap/Support/SkillSwapWidgetPublisher.swift`
- `SkillSwapWidget/SkillSwapWidget.swift`

## Main screens

1. Home
2. Explore
3. Post a Swap
4. Activity
5. Profile
6. Skill Request Detail

## Core Use Cases

- `CreateSkillRequestUseCase`
- `BrowseOpenSkillRequestsUseCase`
- `SubmitSkillOfferUseCase`
- `AcceptSkillOfferUseCase`
- `CloseSkillRequestUseCase`
- `GetMySkillRequestsUseCase`
- `GetIncomingOffersUseCase`
- `GetOffersForRequestUseCase`

## Tests

The project contains more than the required five unit tests. Tests cover Use Case happy paths, boundary rules, domain errors, ownership rules, duplicate offers, category filtering, request matching, competing-offer decline behaviour, closing rules, and mock repository query behaviour.

## Setup

1. Open `SkillSwap.xcodeproj` in Xcode.
2. Select the same Apple Developer Program team for `SkillSwap`, `SkillSwapWidget`, `SkillSwapActionExtension`, and `SkillSwapNotificationContent`.
3. In Signing & Capabilities, confirm the `SkillSwap` and `SkillSwapWidget` targets both have the App Groups capability and the same identifier: `group.com.zadeelsaddik.SkillSwapA3`.
4. Choose an iPhone simulator.
5. Build and run the `SkillSwap` scheme.
6. Add the SkillSwap widget from the simulator Home Screen and verify both Small and Medium sizes.
7. Create or update a request/offer in the app and verify the widget updates.
8. Run unit tests with `Command-U`.

## Signing note

The rubric-compliant WidgetKit implementation depends on an App Group. App Groups require a developer team that can provision the capability. A free Personal Team may show the App Group in red and cannot be used to demonstrate the shared-container flow end-to-end. The source code is intentionally configured to match the assessment criteria rather than bypass that requirement.
