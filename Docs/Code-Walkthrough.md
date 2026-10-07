# SkillSwap Code Walkthrough

## 1. Domain

`SkillRequest` is the central domain entity. It records who posted the request, what skill/help they need, what they can offer, category, availability, and status.

`SkillOffer` belongs to a request and represents another member proposing to help. The domain rules are enforced in Use Cases rather than Views.

## 2. Use Cases

`CreateSkillRequestUseCase` prevents empty one-sided requests and rejects a request where the same skill is used on both sides.

`SubmitSkillOfferUseCase` checks that the request is open, the member is not responding to their own request, required information exists, and the same member has not already offered.

`AcceptSkillOfferUseCase` is the most important transaction. Only the request owner may accept an offer. The request becomes matched, the selected offer becomes accepted, and other pending offers become declined.

## 3. Repository and Core Data

`SkillSwapRepository` hides persistence from the business and presentation layers. `CoreDataSkillSwapRepository` implements the protocol using two related Core Data entities created in `CoreDataStack`.

The meaningful open-board query applies predicates for `statusRaw == open`, `ownerID != currentMemberID`, and optionally `categoryRaw == selectedCategory`.

## 4. Presentation

`RootView` provides five top-level tabs. Each screen owns a ViewModel. ViewModels call Use Cases and convert domain errors into messages the stakeholder can act on.

`RequestDetailView` changes behaviour depending on ownership. A visitor can propose a swap. The request owner can review offers, accept one, close the request, and test the custom session reminder.

## 5. Extensions

The Action Extension receives text or URL content, lets the person specify the two sides of the exchange, then returns a formatted SkillSwap request to the host app.

The Notification Content Extension listens for the `SKILLSWAP_SESSION_REMINDER` category and shows the partner, required skill, and offered skill in a custom notification view.

## WidgetKit and App Group flow

`SkillSwapWidgetPublisher` reads the current member's requests and incoming offers through the repository, writes only the small summary needed by the widget into the App Group `UserDefaults`, and calls `WidgetCenter.reloadTimelines`.

`WidgetPublishingSkillSwapRepository` decorates the normal repository. After each request or offer save/update it republishes the widget snapshot. This means the SwiftUI screens and Use Cases do not need to know about WidgetKit.

The Widget Extension reads the App Group summary and presents it in both Small and Medium families. It does not access Core Data directly.
