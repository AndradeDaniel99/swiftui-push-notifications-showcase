import SwiftUI

@main
struct PushNotificationsShowcaseApp: App {
    @State private var router = NotificationRouter()
    @State private var viewModel: NotificationViewModel

    init() {
        let service = UserNotificationService()
        _viewModel = State(initialValue: NotificationViewModel(service: service))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .environment(router)
                .onAppear {
                    viewModel.bind(router: router)
                }
        }
    }
}
