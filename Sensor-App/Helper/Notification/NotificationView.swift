//
//  NotificationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 29.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct NotificationView: View {
    
    let notificationAPI = NotificationAPI()
    
    // MARK: - @State / @ObservedObject / @Binding
    @Binding var notificationMessage: String
    @Binding var showNotification: Bool
    
    
    // MARK: - Define Constants / Variables
    private var notificationSettings : NotificationAnimationModel
    
    
    // MARK: - Initializer
    init(notificationMessage: Binding<String>, showNotification: Binding<Bool>) {
        _notificationMessage = notificationMessage
        _showNotification = showNotification
        notificationSettings = notificationAPI.fetchNotificationAnimationSettings()
    }
    
    
    // MARK: - Methods
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return NotificationMessageView(notificationText: $notificationMessage)
            .offset(y: showNotification ? notificationSettings.offSetY : -UIScreen.main.bounds.height)
            .animation(.interpolatingSpring(mass: notificationSettings.springMass, stiffness: notificationSettings.springStiffness, damping: notificationSettings.springDamping, initialVelocity: notificationSettings.springVelocity))
    }
}


// MARK: - Preview
struct NotificationView_Previews: PreviewProvider {
    @State static var bool = true
    @State static var test = "Saved"
    
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NotificationView(notificationMessage: $test, showNotification: $bool)
                .colorScheme(scheme)
        }
    }
}
