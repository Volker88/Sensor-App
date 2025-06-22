//
//  ShowErrorAction.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 25.09.2024.
//

import SwiftUI

struct ShowNotificationAction {
    typealias Action = (String) -> Void
    let action: Action
    func callAsFunction(_ message: String) {
        action(message)
    }
}

struct ShowNotificationEnvironmentKey: EnvironmentKey {
    static let defaultValue = ShowNotificationAction { _ in }
}

extension EnvironmentValues {
    var showNotification: (ShowNotificationAction) {
        get { self[ShowNotificationEnvironmentKey.self] }
        set { self[ShowNotificationEnvironmentKey.self] = newValue }
    }
}
