//
//  NotificationModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 28.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import Foundation
import SwiftUI

// MARK: - Class Definition
class NotificationAPI {

    // MARK: - Define Constants / Variables

    // MARK: - Methods
    ///
    ///  Fetches the Notification Animation Settings
    ///
    ///  Fetches the settings for the notification animation and duration. All values are optional. Default values will be provided.
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: NotificationAnimationModel
    ///
    ///  - Parameter offSetY:  Offset in Y direction
    ///  - Parameter mass:  Mass of the view
    ///  - Parameter stiffness: Spring stiffness
    ///  - Parameter damping: Spring damping
    ///  - Parameter velocity: Initial velocity
    ///  - Parameter duration: Duration how long the notification is shown
    ///
    public func fetchNotificationAnimationSettings(
        offSetY: CGFloat? = -UIScreen.main.bounds.height / 3,
        mass: Double? = 1.0,
        stiffness: Double? = 100.0,
        damping: Double? = 10.0,
        velocity: Double? = 0.0,
        duration: Double? = 2.0
    ) -> NotificationAnimationModel {
        let notificationAnimationSettings = NotificationAnimationModel(
            offSetY: offSetY!,
            springMass: mass!,
            springStiffness: stiffness!,
            springDamping: damping!,
            springVelocity: velocity!,
            duration: duration!
        )
        return notificationAnimationSettings
    }

    ///
    ///  Toggles notification based on type and duration
    ///
    ///  Generates the notification message and toggles the notification view
    ///
    ///  # Notification Types
    ///  * saved
    ///  * discarded
    ///  * paused
    ///  * played
    ///  * deleted
    ///
    ///  - Note: Depending on the Notification Type, the notification message will be generated
    ///  - Remark:
    ///
    ///
    ///  - Returns: Notification Message, Boolean to toggle notification
    ///
    ///  - Parameter type: Notification Type
    ///  - Parameter duration: Notification Duration
    ///  - Parameter completion: Completiomn Handler
    public func toggleNotification(
        type: NotificationTypes,
        duration: Double?,
        completion: @escaping (String, Bool) -> Void
    ) {
        let duration = duration ?? fetchNotificationAnimationSettings().duration

        let notificationMessage = fetchNotificationText(type: type)
        var showNotification = true
        completion(notificationMessage, showNotification)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
            showNotification = false
            completion(notificationMessage, showNotification)
        })
    }

    ///
    ///  Fetches Notification Text based on notification Type
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: Notification Text
    ///
    ///  - Parameter type: Notification Type
    ///
    private func fetchNotificationText(type: NotificationTypes) -> String {
        var notificationText = ""
        switch type {
            //swiftlint:disable line_length
            case .saved: notificationText = NSLocalizedString("Saved successfully", comment: "NotificationMessage - Saved")
            case .discarded: notificationText = NSLocalizedString("Changes Discarded", comment: "NotificationMessage - Discarded")
            case .paused: notificationText = NSLocalizedString("Paused", comment: "NotificationMessage - Paused")
            case .played: notificationText = NSLocalizedString("Play", comment: "NotificationMessage - Play")
            case .deleted: notificationText = NSLocalizedString("Successfully deleted", comment: "NotificationMessage - Deleted")
            //swiftlint:enable line_length
        }
        return notificationText
    }
}
