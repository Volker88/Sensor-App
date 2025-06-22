//
//  OpenAttitudeIntent.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 22.06.25.
//

import AppIntents
import SwiftUI

nonisolated struct OpenAttitudeIntent: AppIntent {

    let appState: AppState? = CustomAppDependencyManager.shared.get(key: "AppState")

    // Dependency not working in nonisolated context
    // @Dependency
    // private var appState: AppState

    static let title = LocalizedStringResource("Open Attitude", table: "AppIntents")

    static var description: IntentDescription? {
        IntentDescription(
            LocalizedStringResource("Open Attitude", table: "AppIntents"),
            categoryName: LocalizedStringResource("Motion", table: "AppIntents"),
            searchKeywords: [
                LocalizedStringResource("Motion", table: "AppIntents"),
                LocalizedStringResource("Attitude", table: "AppIntents")
            ],
            resultValueName: nil)
    }

    static let isDiscoverable = true
    static let openAppWhenRun = true

    @MainActor
    func perform() async throws -> some IntentResult {
        if let appState {
            if appState.isIphone {
                appState.selectedTab = .motion

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appState.motionStack = [.attitude]
                }
            } else {
                appState.selectedTab = .attitude
            }
        }

        return .result()
    }
}
