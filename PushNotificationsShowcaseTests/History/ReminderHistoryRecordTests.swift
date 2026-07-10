import Foundation
import Testing
@testable import PushNotificationsShowcase

struct ReminderHistoryRecordTests {
    @Test func preservesSchedulingMetadataFromNotificationContent() {
        let date = Date.now.addingTimeInterval(120)
        let content = ReminderNotificationContent(
            identifier: "record-123",
            title: "Lembrete",
            body: "Enviar relatório",
            date: date,
            delivery: .scheduled
        )

        let record = ReminderHistoryRecord(content: content, createdAt: .now)

        #expect(record.id == "record-123")
        #expect(record.title == "Enviar relatório")
        #expect(record.scheduledFor == date)
        #expect(record.delivery == .scheduled)
    }
}
