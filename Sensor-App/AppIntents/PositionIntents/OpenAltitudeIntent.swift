//
//  OpenAltitudeIntent.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 22.06.25.
//

import AppIntents
import SwiftUI

nonisolated struct OpenAltitudeIntent: AppIntent {

    let appState: AppState? = CustomAppDependencyManager.shared.get(key: "AppState")

    // Dependency not working in nonisolated context
    // @Dependency
    // private var appState: AppState

    static let title = LocalizedStringResource("Open Altitude", table: "AppIntents")

    static var description: IntentDescription? {
        IntentDescription(
            LocalizedStringResource("Open Altitude", table: "AppIntents"),
            categoryName: LocalizedStringResource("Position", table: "AppIntents"),
            searchKeywords: [
                LocalizedStringResource("Position", table: "AppIntents"),
                LocalizedStringResource("Altitude", table: "AppIntents"),
                LocalizedStringResource("Pressure", table: "AppIntents")
            ],
            resultValueName: nil)
    }

    static let isDiscoverable = true
    static let openAppWhenRun = true

    @MainActor
    func perform() async throws -> some IntentResult {
        if let appState {
            if appState.isIphone {
                appState.selectedTab = .position

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appState.positionStack = [.altitude]
                }
            } else {
                appState.selectedTab = .altitude
            }
        }

        return .result()
    }
}
