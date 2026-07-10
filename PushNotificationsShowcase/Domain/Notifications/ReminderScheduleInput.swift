import Foundation

struct ReminderScheduleInput: Equatable {
    let title: String
    let date: Date

    func validated(now: Date = .now) throws -> ReminderScheduleInput {
        let normalizedTitle = try ReminderTitle.validated(title)
        guard date > now else {
            throw ReminderScheduleError.dateMustBeInFuture
        }

        return ReminderScheduleInput(title: normalizedTitle, date: date)
    }
}

enum ReminderScheduleError: LocalizedError, Equatable {
    case emptyTitle
    case dateMustBeInFuture

    var errorDescription: String? {
        switch self {
        case .emptyTitle: "Informe o texto do lembrete."
        case .dateMustBeInFuture: "Escolha uma data futura."
        }
    }
}
