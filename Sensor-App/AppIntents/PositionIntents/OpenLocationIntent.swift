//
//  OpenLocationIntent.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 21.06.25.
//

import AppIntents
import SwiftUI

nonisolated struct OpenLocationIntent: AppIntent {

    let appState: AppState? = CustomAppDependencyManager.shared.get(key: "AppState")

    // Dependency not working in nonisolated context
    // @Dependency
    // private var appState: AppState

    static let title = LocalizedStringResource("Open Location", table: "AppIntents")

    static var description: IntentDescription? {
        IntentDescription(
            LocalizedStringResource("Open Location", table: "AppIntents"),
            categoryName: LocalizedStringResource("Position", table: "AppIntents"),
            searchKeywords: [
                LocalizedStringResource("Position", table: "AppIntents"),
                LocalizedStringResource("Location", table: "AppIntents"),
                LocalizedStringResource("GPS", table: "AppIntents")
            ],
            resultValueName: nil)
    }

    static let isDiscoverable = true
    static let openAppWhenRun = true

    @MainActor
    func perform() async throws -> some IntentResult {
        appState?.appIntentTab = .location

        return .result()
    }
}
