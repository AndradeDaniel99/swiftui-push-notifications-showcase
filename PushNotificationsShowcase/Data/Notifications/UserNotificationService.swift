import Foundation
import UserNotifications

final class UserNotificationService: NSObject, NotificationService, UNUserNotificationCenterDelegate {
    var onReminderOpened: (@MainActor (String) -> Void)?

    private let center: UNUserNotificationCenter

    override init() {
        center = .current()
        super.init()
        center.delegate = self
    }

    func permissionStatus() async -> NotificationPermission {
        let settings = await center.notificationSettings()
        return NotificationPermission(status: settings.authorizationStatus)
    }

    func requestPermission() async throws -> NotificationPermission {
        let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
        return granted ? .authorized : .denied
    }

    func schedule(_ content: ReminderNotificationContent) async throws {
        guard await permissionStatus().canSchedule else {
            throw NotificationServiceError.permissionDenied
        }

        let components = Calendar.current.dateComponents([.calendar, .timeZone, .year, .month, .day, .hour, .minute], from: content.date)
        let request = UNNotificationRequest(
            identifier: content.identifier,
            content: makeSystemContent(from: content),
            trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        )
        try await center.add(request)
    }

    func sendNow(_ content: ReminderNotificationContent) async throws {
        guard await permissionStatus().canSchedule else {
            throw NotificationServiceError.permissionDenied
        }

        let request = UNNotificationRequest(
            identifier: content.identifier,
            content: makeSystemContent(from: content),
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        try await center.add(request)
    }

    private func makeSystemContent(from content: ReminderNotificationContent) -> UNMutableNotificationContent {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = content.title
        notificationContent.body = content.body
        notificationContent.sound = .default
        notificationContent.userInfo = ["reminderID": content.identifier]
        return notificationContent
    }

    nonisolated func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent _: UNNotification,
        withCompletionHandler completionHandler: @escaping @Sendable (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }

    nonisolated func userNotificationCenter(
        _: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping @Sendable () -> Void
    ) {
        let identifier = response.notification.request.identifier
        Task { @MainActor [weak self] in
            self?.onReminderOpened?(identifier)
            completionHandler()
        }
    }
}

private extension NotificationPermission {
    init(status: UNAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .notDetermined
        case .denied: self = .denied
        case .authorized: self = .authorized
        case .provisional, .ephemeral: self = .provisional
        @unknown default: self = .denied
        }
    }
}
