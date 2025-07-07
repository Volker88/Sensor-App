//
//  SensorAppShortcuts.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 21.06.25.
//

import AppIntents
import SwiftUI

struct SensorAppShortchuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {

        AppShortcut(
            intent: NavigateIntent(),
            phrases: [
                "Navigate in \(.applicationName)",
                "Navigate to \(\.$navigationOption) in \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource("Navigate"),
            systemImageName: "arrowshape.forward"
        )
    }
}
