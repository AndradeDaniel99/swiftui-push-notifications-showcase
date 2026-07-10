import Foundation

struct ReminderHistoryRecord: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let delivery: ReminderDelivery
    let createdAt: Date
    let scheduledFor: Date

    init(content: ReminderNotificationContent, createdAt: Date = .now) {
        id = content.identifier
        title = content.body
        delivery = content.delivery
        self.createdAt = createdAt
        scheduledFor = content.date
    }
}

enum ReminderDelivery: String, Codable, Equatable {
    case scheduled
    case immediate

    var title: String {
        switch self {
        case .scheduled: "Agendado"
        case .immediate: "Enviado agora"
        }
    }

    var systemImage: String {
        switch self {
        case .scheduled: "calendar"
        case .immediate: "bell.badge.fill"
        }
    }
}
