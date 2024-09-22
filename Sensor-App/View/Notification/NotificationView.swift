//
//  ErrorView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 25.09.2024.
//

import SwiftUI

struct NotificationView: View {

    @Binding var notificationWrapper: NotificationWrapper?

    // MARK: - Body
    var body: some View {
        VStack {
            Text(notificationWrapper?.message ?? "")
        }.task(id: notificationWrapper?.id) {
            // delay
            try? await Task.sleep(for: .seconds(1))
            guard !Task.isCancelled else { return }

            notificationWrapper = nil
        }
        .foregroundStyle(.white)
        .padding()
        .background(.green)
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
    }
}

// MARK: - Preview
#Preview {
    NotificationView(notificationWrapper: .constant(
        NotificationWrapper(message: "Start")
    ))
}

/// ``NotificationWrapper`` Model
struct NotificationWrapper: Identifiable {

    /// ID
    let id = UUID()

    /// message
    let message: String
}
