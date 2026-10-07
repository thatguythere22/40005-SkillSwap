import Foundation
import UserNotifications

/// Schedules local reminders for confirmed skill-swap sessions.
final class SessionReminderService {
    static let categoryIdentifier = "SKILLSWAP_SESSION_REMINDER"

    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    func scheduleDemoReminder(
        partnerName: String,
        needSkill: String,
        offeredSkill: String
    ) async throws {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "SkillSwap session reminder"
        content.body = "Your exchange with \(partnerName) is coming up."
        content.sound = .default
        content.categoryIdentifier = Self.categoryIdentifier
        content.userInfo = [
            "partnerName": partnerName,
            "needSkill": needSkill,
            "offeredSkill": offeredSkill
        ]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 8, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        try await center.add(request)
    }
}
