import Foundation
import Observation

@MainActor
@Observable
final class NotificationViewModel {
    private let service: NotificationService
    private let historyStore: ReminderHistoryStoring

    var permission: NotificationPermission = .notDetermined
    var reminderTitle = "Drink water"
    var reminderDate = Date.now.addingTimeInterval(300)
    var isLoading = false
    var confirmationMessage = ""
    var errorMessage = ""
    var isShowingConfirmation = false
    var isShowingError = false
    private(set) var history: [ReminderHistoryRecord] = []

    init(service: NotificationService, historyStore: ReminderHistoryStoring = UserDefaultsReminderHistoryStore()) {
        self.service = service
        self.historyStore = historyStore
    }

    func bind(router: NotificationRouter) {
        service.onReminderOpened = { identifier in
            router.destination = .reminder(id: identifier)
        }
    }

    func refreshPermission() async {
        permission = await service.permissionStatus()
    }

    func loadHistory() {
        history = historyStore.load().sorted { $0.createdAt > $1.createdAt }
    }

    func requestPermission() async {
        isLoading = true
        defer { isLoading = false }

        do {
            permission = try await service.requestPermission()
        } catch {
            errorMessage = error.localizedDescription
            isShowingError = true
        }
    }

    func scheduleReminder() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let input = try ReminderScheduleInput(title: reminderTitle, date: reminderDate).validated()
            let content = ReminderNotificationContentFactory.scheduled(from: input)
            try await service.schedule(content)
            addToHistory(content)
            confirmationMessage = "Reminder scheduled for \(content.date.formatted(date: .abbreviated, time: .shortened))."
            isShowingConfirmation = true
        } catch {
            errorMessage = error.localizedDescription
            isShowingError = true
        }
    }

    func sendReminderNow() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let content = try ReminderNotificationContentFactory.immediate(title: reminderTitle)
            try await service.sendNow(content)
            addToHistory(content)
            confirmationMessage = "Reminder sent. It will appear shortly."
            isShowingConfirmation = true
        } catch {
            errorMessage = error.localizedDescription
            isShowingError = true
        }
    }

    private func addToHistory(_ content: ReminderNotificationContent) {
        history.insert(ReminderHistoryRecord(content: content), at: 0)
        historyStore.save(history)
    }
}
