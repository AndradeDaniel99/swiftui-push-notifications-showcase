import SwiftUI

struct ContentView: View {
    @Environment(NotificationRouter.self) private var router
    @Bindable var viewModel: NotificationViewModel

    var body: some View {
        @Bindable var router = router

        NavigationStack {
            Form {
                permissionSection
                reminderSection
                historySection
            }
            .navigationTitle("Lembretes")
            .navigationDestination(item: $router.destination) { destination in
                switch destination {
                case let .reminder(id):
                    ReminderDetailView(reminderID: id)
                }
            }
            .task {
                await viewModel.refreshPermission()
                viewModel.loadHistory()
            }
            .alert("Não foi possível concluir", isPresented: $viewModel.isShowingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .alert("Tudo certo", isPresented: $viewModel.isShowingConfirmation) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.confirmationMessage)
            }
        }
    }

    private var permissionSection: some View {
        Section("Notificações") {
            Label(viewModel.permission.title, systemImage: permissionIcon)
                .foregroundStyle(permissionColor)
            Text(viewModel.permission.detail)
                .font(.footnote)
                .foregroundStyle(.secondary)

            if viewModel.permission == .notDetermined {
                Button("Permitir notificações", systemImage: "bell.badge") {
                    Task { await viewModel.requestPermission() }
                }
                .disabled(viewModel.isLoading)
            }
        }
    }

    private var reminderSection: some View {
        Section("Novo lembrete") {
            TextField("Texto do lembrete", text: $viewModel.reminderTitle)
            DatePicker("Quando", selection: $viewModel.reminderDate, in: Date.now..., displayedComponents: [.date, .hourAndMinute])

            Button("Enviar agora", systemImage: "bell.badge.fill") {
                Task { await viewModel.sendReminderNow() }
            }
            .disabled(!viewModel.permission.canSchedule || viewModel.isLoading)

            Button("Agendar lembrete", systemImage: "calendar.badge.plus") {
                Task { await viewModel.scheduleReminder() }
            }
            .disabled(!viewModel.permission.canSchedule || viewModel.isLoading)
        }
    }

    @ViewBuilder
    private var historySection: some View {
        Section("Histórico") {
            if viewModel.history.isEmpty {
                ContentUnavailableView(
                    "Nenhum lembrete enviado",
                    systemImage: "clock",
                    description: Text("Os lembretes enviados ou agendados aparecerão aqui.")
                )
            } else {
                ForEach(viewModel.history) { record in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: record.delivery.systemImage)
                            .foregroundStyle(record.delivery == .immediate ? .orange : .blue)
                            .accessibilityHidden(true)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(record.title)
                            Text(record.delivery.title)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text(historyDate(for: record))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.trailing)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }

    private func historyDate(for record: ReminderHistoryRecord) -> String {
        switch record.delivery {
        case .immediate:
            record.createdAt.formatted(date: .abbreviated, time: .shortened)
        case .scheduled:
            record.scheduledFor.formatted(date: .abbreviated, time: .shortened)
        }
    }

    private var permissionIcon: String {
        switch viewModel.permission {
        case .authorized, .provisional: "checkmark.circle.fill"
        case .denied: "xmark.circle.fill"
        case .notDetermined: "questionmark.circle.fill"
        }
    }

    private var permissionColor: Color {
        switch viewModel.permission {
        case .authorized, .provisional: .green
        case .denied: .red
        case .notDetermined: .orange
        }
    }
}

#Preview {
    ContentView(viewModel: NotificationViewModel(service: PreviewNotificationService()))
        .environment(NotificationRouter())
}
