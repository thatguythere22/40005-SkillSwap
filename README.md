# SkillSwap

SkillSwap is an iOS app built around a simple idea: people often need help with something but may not want to pay for a full service, while at the same time they usually have a skill of their own that could be useful to someone else.

The app lets a person post what they need help with and what they can offer in return. For example, someone might need help fixing a bike but be able to offer Photoshop help, tutoring, language practice or something similar.

The main goal of SkillSwap is to make small skill exchanges easier to organise without turning everything into a normal money-based marketplace.

## Domain Context

The main stakeholder for SkillSwap is a university student or young adult who may have limited disposable income but still has useful skills they can exchange with other people.

The problem SkillSwap is trying to solve is the friction around small, practical exchanges. A person may need help with something relatively minor, but paying for a professional service may not make sense. At the same time, informal arrangements through messages or social media can be difficult to organise and keep track of.

SkillSwap gives these exchanges a clearer structure. A request contains both the skill the person needs and the skill they are willing to offer in return. Other members can browse open requests and make an offer if they are interested in the exchange.

## Main Features

The app includes:

- browsing currently open skill requests
- creating a new request with a needed skill and an offered skill
- viewing request details
- submitting offers on another member's request
- accepting an offer
- closing a request when it is no longer available
- viewing personal requests and incoming offers
- persistent storage using Core Data
- a Home Screen widget showing useful SkillSwap information
- custom session reminder notifications
- an Action Extension for bringing relevant content into SkillSwap

## Architecture

SkillSwap uses a layered architecture based on MVVM with a separate Use Case layer.

The main flow is:

`SwiftUI Views -> ViewModels -> Use Cases -> Repository -> Core Data`

The Views are responsible for presenting information and receiving user input. ViewModels prepare data for the interface and call the relevant Use Cases.

The Use Case layer contains the business rules for the app. This includes operations such as creating a skill request, submitting an offer, accepting an offer and closing a request.

The repository is defined through a protocol so that the app is not directly tied to Core Data. This also makes it possible to use a mock repository in unit tests.

The main domain models include `SkillRequest` and `SkillOffer`, along with domain-specific status and category types.

## Business Rules

Some of the main business rules enforced by the app are:

- a request must include both a skill that is needed and a skill being offered
- a member cannot submit an offer on their own request
- offers cannot be submitted to a closed request
- only one offer can be accepted for a request
- accepting an offer changes the state of the request and the related offers
- errors are shown using domain-specific messages rather than generic technical errors

These rules are handled in the Use Case layer rather than directly inside the SwiftUI views.

## Database Choice

SkillSwap uses Core Data for its main persistent storage.

Core Data was chosen because the app needs fast local persistence and structured relationships between requests and offers. The main data belongs to the app and needs to remain available between launches without depending on a network connection.

The repository layer sits between Core Data and the rest of the application so that Views and ViewModels do not access Core Data directly.

The main stored entities represent skill exchange requests and the offers attached to those requests.

## System Extensions

### WidgetKit Widget

The SkillSwap widget gives the user useful information without requiring them to open the full app.

It reads a lightweight snapshot of SkillSwap data from the shared App Group container and supports more than one widget size.

The main app updates the shared widget data when relevant SkillSwap data changes and asks WidgetKit to refresh the widget timeline.

This is useful for someone who wants to quickly check their current SkillSwap activity from the Home Screen.

### Notification Content Extension

SkillSwap uses a Notification Content Extension for exchange session reminders.

When a user has matched with another person, the reminder notification can display exchange-specific information such as the other person's name, the skill the user needs and the skill they are offering.

This gives the notification more useful context than a generic reminder.

### Action Extension

The Action Extension allows content from another app to be used as the starting point for a SkillSwap draft.

This makes it easier to bring useful text into SkillSwap without manually switching between apps and retyping it.

The extension communicates through the shared App Group container.

## App Group

The shared App Group used by the app and its extensions is:

`group.com.zadeelsaddik.SkillSwapA3`

The App Group is used to share lightweight data between the main app and system extensions, especially the Widget and Action Extension.

## Project Structure

The project is organised roughly as follows:

```text
SkillSwap/
├── Domain/
│   ├── Models/
│   ├── Repositories/
│   └── UseCases/
├── Data/
├── Presentation/
│   ├── Components/
│   ├── ViewModels/
│   └── Views/
├── Support/
├── SkillSwapWidget/
├── SkillSwapNotificationContent/
├── SkillSwapActionExtension/
└── SkillSwapTests/
