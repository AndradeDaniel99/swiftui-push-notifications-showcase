final class PreviewNotificationService: NotificationService {
    var onReminderOpened: (@MainActor (String) -> Void)?

    func permissionStatus() async -> NotificationPermission { .authorized }
    func requestPermission() async throws -> NotificationPermission { .authorized }
    func schedule(_: ReminderNotificationContent) async throws {}
    func sendNow(_: ReminderNotificationContent) async throws {}
}
