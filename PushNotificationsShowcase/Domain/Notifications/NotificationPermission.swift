enum NotificationPermission: Equatable {
    case notDetermined
    case denied
    case authorized
    case provisional

    var canSchedule: Bool {
        self == .authorized || self == .provisional
    }

    var title: String {
        switch self {
        case .notDetermined: "Permission Not Requested"
        case .denied: "Notifications Disabled"
        case .authorized: "Notifications Enabled"
        case .provisional: "Provisional Notifications Enabled"
        }
    }

    var detail: String {
        switch self {
        case .notDetermined: "Allow notifications to receive reminders on this device."
        case .denied: "Enable notifications in iOS Settings to schedule reminders."
        case .authorized, .provisional: "You can schedule a local reminder now."
        }
    }
}
