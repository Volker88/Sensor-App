//
//  OpenGyroscopeIntent.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 22.06.25.
//

import AppIntents
import SwiftUI

nonisolated struct OpenGyroscopeIntent: AppIntent {

    let appState: AppState? = CustomAppDependencyManager.shared.get(key: "AppState")

    // Dependency not working in nonisolated context
    // @Dependency
    // private var appState: AppState

    static let title = LocalizedStringResource("Open Gyroscope", table: "AppIntents")

    static var description: IntentDescription? {
        IntentDescription(
            LocalizedStringResource("Open Gyroscope", table: "AppIntents"),
            categoryName: LocalizedStringResource("Motion", table: "AppIntents"),
            searchKeywords: [
                LocalizedStringResource("Motion", table: "AppIntents"),
                LocalizedStringResource("Gyroscope", table: "AppIntents")
            ],
            resultValueName: nil)
    }

    static let isDiscoverable = true
    static let openAppWhenRun = true

    @MainActor
    func perform() async throws -> some IntentResult {
        appState?.appIntentTab = .gyroscope

        return .result()
    }
}
