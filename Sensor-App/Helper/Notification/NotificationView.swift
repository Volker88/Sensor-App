//
//  NotificationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 29.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct NotificationView: View {
    @Binding var notificationMessage: String
    @Binding var showNotification: Bool

    private let notificationAPI = NotificationAPI()
    private var notificationSettings: NotificationAnimationModel

    init(notificationMessage: Binding<String>, showNotification: Binding<Bool>) {
        _notificationMessage = notificationMessage
        _showNotification = showNotification
        notificationSettings = notificationAPI.fetchNotificationAnimationSettings()
    }

    var body: some View {
        NotificationMessageView(notificationText: $notificationMessage)
            .offset(y: showNotification ? notificationSettings.offSetY : -UIScreen.main.bounds.height)
            .animation(
                .interpolatingSpring(
                    mass: notificationSettings.springMass,
                    stiffness: notificationSettings.springStiffness,
                    damping: notificationSettings.springDamping,
                    initialVelocity: notificationSettings.springVelocity
                ),
                value: showNotification
            )
    }
}

struct NotificationView_Previews: PreviewProvider {
    @State static var bool = true
    @State static var test = "Saved"

    static var previews: some View {
        NotificationView(notificationMessage: $test, showNotification: $bool)
    }
}
