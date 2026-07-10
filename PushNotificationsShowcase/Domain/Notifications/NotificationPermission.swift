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
        case .notDetermined: "Permissão ainda não solicitada"
        case .denied: "Notificações desativadas"
        case .authorized: "Notificações ativadas"
        case .provisional: "Notificações provisórias ativadas"
        }
    }

    var detail: String {
        switch self {
        case .notDetermined: "Autorize para receber lembretes neste dispositivo."
        case .denied: "Ative as notificações nos Ajustes do iOS para agendar lembretes."
        case .authorized, .provisional: "Você pode agendar um lembrete local agora."
        }
    }
}
