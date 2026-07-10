import Foundation
import Testing
@testable import PushNotificationsShowcase

struct ReminderScheduleInputTests {
    @Test func trimsTitleWhenInputIsValid() throws {
        let date = Date.now.addingTimeInterval(60)
        let result = try ReminderScheduleInput(title: "  Beber água  ", date: date).validated(now: .now)

        #expect(result.title == "Beber água")
    }

    @Test func rejectsEmptyTitle() {
        #expect(throws: ReminderScheduleError.emptyTitle) {
            try ReminderScheduleInput(title: "   ", date: .now.addingTimeInterval(60)).validated()
        }
    }

    @Test func rejectsDateInThePast() {
        #expect(throws: ReminderScheduleError.dateMustBeInFuture) {
            try ReminderScheduleInput(title: "Pausa", date: .now.addingTimeInterval(-1)).validated()
        }
    }
}
