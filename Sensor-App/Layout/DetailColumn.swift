//
//  DetailColumn.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import Sensor_App_Framework
import SwiftUI

struct DetailColumn: View {

    @Environment(AppState.self) private var appState

    // MARK: - Body
    var body: some View {
        appState.selectedScreen ?? .homeScreen
    }
}

// MARK: - Preview
#Preview("DetailColumn - English", traits: .navEmbedded) {
    ContentView()
}

#Preview("DetailColumn - German", traits: .navEmbedded) {
    ContentView()
        .previewLocalization(.german)
}
