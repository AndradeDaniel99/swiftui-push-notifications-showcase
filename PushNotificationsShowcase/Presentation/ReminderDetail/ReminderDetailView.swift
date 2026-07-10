import SwiftUI

struct ReminderDetailView: View {
    let reminderID: String

    var body: some View {
        ContentUnavailableView {
            Label("Reminder Opened", systemImage: "bell.and.waves.left.and.right.fill")
        } description: {
            Text("This screen opened after tapping the local notification.")
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Reminder ID: \(reminderID)")
    }
}
