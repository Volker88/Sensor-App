//
//  NavigationIntent.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 26.06.25.
//

import AppIntents
import SwiftUI

struct NavigateIntent: AppIntent {

    @Dependency
    private var appState: AppState

    @Parameter
    var navigationOption: NavigationOption

    static let title = LocalizedStringResource("Navigate to Section")

    static var description: IntentDescription? {
        IntentDescription(
            LocalizedStringResource("Navigate to Section"),
            categoryName: LocalizedStringResource("Navigation"),
            searchKeywords: [
                LocalizedStringResource("Location"),
                LocalizedStringResource("Altitude"),
                LocalizedStringResource("Acceleration"),
                LocalizedStringResource("Altitude"),
                LocalizedStringResource("Gravity"),
                LocalizedStringResource("Gyroscope"),
                LocalizedStringResource("Magnetometer")
            ],
            resultValueName: nil
        )
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Navigate to \(\.$navigationOption)")
    }

    static let supportedModes: IntentModes = .foreground

    @MainActor
    func perform() async throws -> some IntentResult {
        switch navigationOption {
            case .location:
                appState.appIntentTab = .location
            case .acceleration:
                appState.appIntentTab = .acceleration
            case .altitude:
                appState.appIntentTab = .altitude
            case .gravity:
                appState.appIntentTab = .gravity
            case .gyroscope:
                appState.appIntentTab = .gyroscope
            case .attitude:
                appState.appIntentTab = .attitude
            case .magnetometer:
                appState.appIntentTab = .magnetometer
            case .settings:
                appState.appIntentTab = .settings
        }

        return .result()
    }
}
