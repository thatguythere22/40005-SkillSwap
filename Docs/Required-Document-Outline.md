# Assessment 3 Required Document Outline

The final submission requires one PDF containing all four sections.

## Section 1: Problem Statement

Define the specific stakeholder and skill-exchange problem. Add at least one real-world source before submission.

## Section 2: Design Justification

Explain why an iOS app fits the stakeholder workflow. Justify each implemented extension with a concrete user scenario:

- **WidgetKit Widget:** the stakeholder can see pending offers and active swaps from the Home Screen without opening SkillSwap.
- **Notification Content Extension:** a matched exchange reminder shows the exchange partner and swap details in domain language.
- **Action Extension:** selected text or a URL can be turned into a structured two-sided skill request draft.

Justify Core Data as the local structured store for requests and related offers. Explain that the widget receives a compact snapshot through the App Group rather than accessing Core Data directly.

## Section 3: Architecture Diagram

Show:

`Human -> SwiftUI -> ViewModel -> Use Case -> SkillSwapRepository -> Core Data`

Also show:

`Core Data / Repository -> Widget Publisher -> App Group -> WidgetKit`

and the call from the main app to `WidgetCenter.reloadTimelines` after relevant data changes.

Show the Notification Content Extension as a separate system surface for the `SKILLSWAP_SESSION_REMINDER` notification category, and the Action Extension returning formatted content to the host application.

## Section 4: Reflective Report

700-900 words addressing the five prompts in the brief, including declared AI use.
