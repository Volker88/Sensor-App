//
//  PositionScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.06.25.
//

import SwiftUI

struct PositionScreen: View {

    @Environment(AppState.self) private var appState

    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 20)
    ]

    // MARK: - Body
    var body: some View {
        NavigationStack(path: Bindable(appState).positionStack) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    NavigationLink(value: PositionStack.location) {
                        CardView {
                            Text("Location")
                        }
                    }
                    .accessibilityIdentifier(UIIdentifiers.PositionScreen.locationButton)

                    NavigationLink(value: PositionStack.altitude) {
                        CardView {
                            Text("Altitude")
                        }
                    }
                    .accessibilityIdentifier(UIIdentifiers.PositionScreen.altitudeButton)
                }
                .frame(maxWidth: 360)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Position")
            .navigationSubtitle("Select a position type")
            .navigationDestination(for: PositionStack.self) { $0 }
        }
    }
}

// MARK: - Preview
#Preview("PositionScreen - English", traits: .navEmbedded) {
    PositionScreen()
        .environment(AppState())
}

#Preview("PositionScreen - German", traits: .navEmbedded) {
    PositionScreen()
        .previewLocalization(.german)
        .environment(AppState())
}
