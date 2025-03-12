//
//  NotificationModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 25.09.2024.
//

import SwiftUI

struct NotificationModifier: ViewModifier {

    @State private var notificationWrapper: NotificationWrapper?

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .top) {
                if notificationWrapper != nil {
                    NotificationView(notificationWrapper: $notificationWrapper)
                        .padding()

                }
            }.environment(\.showNotification, ShowNotificationAction(action: showNotification))
    }

    private func showNotification(message: String) {
        notificationWrapper = NotificationWrapper(message: message)
    }
}

extension View {
    func withNotificationView() -> some View {
        modifier(NotificationModifier())
    }
}
