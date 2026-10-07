import SwiftUI
import WidgetKit

private enum SkillSwapWidgetShared {
    static let appGroupIdentifier = "group.com.zadeelsaddik.SkillSwapA3"
    static let widgetKind = "SkillSwapWidget"

    enum Keys {
        static let activeRequestCount = "widget.activeRequestCount"
        static let incomingOfferCount = "widget.incomingOfferCount"
        static let featuredNeed = "widget.featuredNeed"
        static let featuredOffer = "widget.featuredOffer"
        static let updatedAt = "widget.updatedAt"
    }
}

struct SkillSwapWidgetEntry: TimelineEntry {
    let date: Date
    let activeRequestCount: Int
    let incomingOfferCount: Int
    let featuredNeed: String
    let featuredOffer: String
}

struct SkillSwapWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> SkillSwapWidgetEntry {
        SkillSwapWidgetEntry(
            date: .now,
            activeRequestCount: 2,
            incomingOfferCount: 1,
            featuredNeed: "Help editing a short video",
            featuredOffer: "Maths tutoring"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SkillSwapWidgetEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SkillSwapWidgetEntry>) -> Void) {
        let entry = loadEntry()
        let refresh = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now.addingTimeInterval(1800)
        completion(Timeline(entries: [entry], policy: .after(refresh)))
    }

    private func loadEntry() -> SkillSwapWidgetEntry {
        guard let defaults = UserDefaults(suiteName: SkillSwapWidgetShared.appGroupIdentifier) else {
            return SkillSwapWidgetEntry(
                date: .now,
                activeRequestCount: 0,
                incomingOfferCount: 0,
                featuredNeed: "No active requests",
                featuredOffer: "Post a swap to get started"
            )
        }

        return SkillSwapWidgetEntry(
            date: .now,
            activeRequestCount: defaults.integer(forKey: SkillSwapWidgetShared.Keys.activeRequestCount),
            incomingOfferCount: defaults.integer(forKey: SkillSwapWidgetShared.Keys.incomingOfferCount),
            featuredNeed: defaults.string(forKey: SkillSwapWidgetShared.Keys.featuredNeed) ?? "No active requests",
            featuredOffer: defaults.string(forKey: SkillSwapWidgetShared.Keys.featuredOffer) ?? "Post a swap to get started"
        )
    }
}

struct SkillSwapWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    let entry: SkillSwapWidgetEntry

    var body: some View {
        switch family {
        case .systemMedium:
            mediumLayout
        default:
            smallLayout
        }
    }

    private var smallLayout: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("SkillSwap", systemImage: "arrow.left.arrow.right.circle.fill")
                .font(.headline)

            Spacer(minLength: 2)

            Text("\(entry.incomingOfferCount)")
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Text(entry.incomingOfferCount == 1 ? "pending offer" : "pending offers")
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer(minLength: 2)

            Text("\(entry.activeRequestCount) active swaps")
                .font(.caption2.weight(.semibold))
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private var mediumLayout: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Label("SkillSwap", systemImage: "arrow.left.arrow.right.circle.fill")
                    .font(.headline)

                Text(entry.featuredNeed)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)

                Label(entry.featuredOffer, systemImage: "gift.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 4)

            VStack(alignment: .trailing, spacing: 10) {
                metric(value: entry.incomingOfferCount, label: "offers")
                metric(value: entry.activeRequestCount, label: "active")
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private func metric(value: Int, label: String) -> some View {
        VStack(alignment: .trailing, spacing: 1) {
            Text("\(value)")
                .font(.title2.bold())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

struct SkillSwapWidget: Widget {
    let kind = SkillSwapWidgetShared.widgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SkillSwapWidgetProvider()) { entry in
            SkillSwapWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("SkillSwap Exchange")
        .description("See active skill exchanges and pending offers without opening SkillSwap.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct SkillSwapWidgetBundle: WidgetBundle {
    var body: some Widget {
        SkillSwapWidget()
    }
}
