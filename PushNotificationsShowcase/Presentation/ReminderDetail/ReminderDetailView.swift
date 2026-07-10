import SwiftUI

struct ReminderDetailView: View {
    let reminderID: String

    var body: some View {
        ContentUnavailableView {
            Label("Lembrete aberto", systemImage: "bell.and.waves.left.and.right.fill")
        } description: {
            Text("Esta tela foi aberta ao tocar na notificação local.")
        }
        .navigationTitle("Detalhe")
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Identificador do lembrete: \(reminderID)")
    }
}
