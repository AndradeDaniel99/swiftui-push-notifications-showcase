import Foundation

protocol NotificationService: AnyObject {
    var onReminderOpened: (@MainActor (String) -> Void)? { get set }

    func permissionStatus() async -> NotificationPermission
    func requestPermission() async throws -> NotificationPermission
    func schedule(_ content: ReminderNotificationContent) async throws
    func sendNow(_ content: ReminderNotificationContent) async throws
}

enum NotificationServiceError: LocalizedError {
    case permissionDenied

    var errorDescription: String? {
        "As notificações não estão autorizadas neste dispositivo."
    }
}
