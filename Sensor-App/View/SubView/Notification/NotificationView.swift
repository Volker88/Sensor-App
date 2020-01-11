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
    
    // MARK: - @State / @Binding Variables
    @Binding var notificationMessage: String
    @Binding var showNotification: Bool
    
    
    // MARK: - Define Constants / Variables
    private let notificationSettings = NotificationAPI.shared.fetchNotificationAnimationSettings()
    
    
    // MARK: - Methods
    
    
    // MARK: - Body - View
    var body: some View {
        
        // MARK: - Return View
        return NotificationMessageView(notificationText: self.$notificationMessage)
            .offset(y: self.showNotification ? notificationSettings.offSetY : -UIScreen.main.bounds.height)
            .animation(.interpolatingSpring(mass: notificationSettings.springMass, stiffness: notificationSettings.springStiffness, damping: notificationSettings.springDamping, initialVelocity: notificationSettings.springVelocity))
    }
}


// MARK: - Preview
struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NotificationView(notificationMessage: .constant("Saved successfully"), showNotification: .constant(true))
                .colorScheme(scheme)
        }
    }
}
