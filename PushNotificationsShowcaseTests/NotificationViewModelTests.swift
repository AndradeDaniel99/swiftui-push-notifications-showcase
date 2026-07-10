import Testing
@testable import PushNotificationsShowcase

@MainActor
struct NotificationViewModelTests {
    @Test func sendingNowAddsAnImmediateReminderToHistory() async {
        let service = NotificationServiceSpy()
        let historyStore = InMemoryHistoryStore()
        let viewModel = NotificationViewModel(service: service, historyStore: historyStore)
        viewModel.reminderTitle = "Revisar pull request"

        await viewModel.sendReminderNow()

        #expect(service.sentImmediately.count == 1)
        #expect(viewModel.history.count == 1)
        #expect(viewModel.history.first?.title == "Revisar pull request")
        #expect(viewModel.history.first?.delivery == .immediate)
        #expect(historyStore.records == viewModel.history)
    }
}

@MainActor
private final class NotificationServiceSpy: NotificationService {
    var onReminderOpened: (@MainActor (String) -> Void)?
    private(set) var sentImmediately: [ReminderNotificationContent] = []

    func permissionStatus() async -> NotificationPermission { .authorized }
    func requestPermission() async throws -> NotificationPermission { .authorized }
    func schedule(_: ReminderNotificationContent) async throws {}

    func sendNow(_ content: ReminderNotificationContent) async throws {
        sentImmediately.append(content)
    }
}

@MainActor
private final class InMemoryHistoryStore: ReminderHistoryStoring {
    private(set) var records: [ReminderHistoryRecord] = []

    func load() -> [ReminderHistoryRecord] { records }
    func save(_ records: [ReminderHistoryRecord]) { self.records = records }
}
