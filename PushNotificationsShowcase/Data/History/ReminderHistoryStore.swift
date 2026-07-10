import Foundation

@MainActor
protocol ReminderHistoryStoring: AnyObject {
    func load() -> [ReminderHistoryRecord]
    func save(_ records: [ReminderHistoryRecord])
}

@MainActor
final class UserDefaultsReminderHistoryStore: ReminderHistoryStoring {
    private let defaults: UserDefaults
    private let key = "reminderHistory"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> [ReminderHistoryRecord] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([ReminderHistoryRecord].self, from: data)) ?? []
    }

    func save(_ records: [ReminderHistoryRecord]) {
        guard let data = try? JSONEncoder().encode(records) else { return }
        defaults.set(data, forKey: key)
    }
}
