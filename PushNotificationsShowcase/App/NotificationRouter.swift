import Observation

@MainActor
@Observable
final class NotificationRouter {
    var destination: Destination?

    enum Destination: Hashable {
        case reminder(id: String)
    }
}
