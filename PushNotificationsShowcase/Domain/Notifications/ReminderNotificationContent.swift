import Foundation

struct ReminderNotificationContent: Equatable {
    let identifier: String
    let title: String
    let body: String
    let date: Date
    let delivery: ReminderDelivery
}

enum ReminderNotificationContentFactory {
    static func scheduled(from input: ReminderScheduleInput, identifier: String = UUID().uuidString) -> ReminderNotificationContent {
        ReminderNotificationContent(
            identifier: identifier,
            title: "Reminder",
            body: input.title,
            date: input.date,
            delivery: .scheduled
        )
    }

    static func immediate(title: String, now: Date = .now, identifier: String = UUID().uuidString) throws -> ReminderNotificationContent {
        ReminderNotificationContent(
            identifier: identifier,
            title: "Reminder",
            body: try ReminderTitle.validated(title),
            date: now,
            delivery: .immediate
        )
    }
}
