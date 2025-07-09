//
//  ShowErrorAction.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 25.09.2024.
//

import SwiftUI

struct ShowNotificationAction {
    typealias Action = (LocalizedStringResource) -> Void
    let action: Action
    func callAsFunction(_ message: LocalizedStringResource) {
        action(message)
    }
}

struct ShowNotificationEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue = ShowNotificationAction { _ in }
}

extension EnvironmentValues {
    var showNotification: (ShowNotificationAction) {
        get { self[ShowNotificationEnvironmentKey.self] }
        set { self[ShowNotificationEnvironmentKey.self] = newValue }
    }
}
