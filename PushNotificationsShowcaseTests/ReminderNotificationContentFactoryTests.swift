import Foundation
import Testing
@testable import PushNotificationsShowcase

struct ReminderNotificationContentFactoryTests {
    @Test func buildsExpectedLocalNotificationContent() {
        let date = Date.now.addingTimeInterval(600)
        let input = ReminderScheduleInput(title: "Reunião de planejamento", date: date)

        let result = ReminderNotificationContentFactory.scheduled(from: input, identifier: "reminder-123")

        #expect(result.identifier == "reminder-123")
        #expect(result.title == "Lembrete")
        #expect(result.body == "Reunião de planejamento")
        #expect(result.date == date)
        #expect(result.delivery == .scheduled)
    }

    @Test func buildsImmediateNotificationWithNormalizedTitle() throws {
        let now = Date.now

        let result = try ReminderNotificationContentFactory.immediate(title: "  Pausa  ", now: now, identifier: "reminder-now")

        #expect(result.identifier == "reminder-now")
        #expect(result.body == "Pausa")
        #expect(result.date == now)
        #expect(result.delivery == .immediate)
    }
}
