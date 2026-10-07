import Foundation

enum DateDisplayFormatter {
    static let relative: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    static func relativeString(for date: Date) -> String {
        relative.localizedString(for: date, relativeTo: Date())
    }
}
