import Foundation

enum ReminderTitle {
    static func validated(_ value: String) throws -> String {
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalized.isEmpty else {
            throw ReminderScheduleError.emptyTitle
        }

        return normalized
    }
}
