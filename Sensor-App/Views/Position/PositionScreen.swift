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
                            Image(systemName: RootTab.location.symbolImage)
                            Text(RootTab.location.stringValue)
                        }
                    }
                    .accessibilityIdentifier(UIIdentifiers.PositionScreen.locationButton)

                    NavigationLink(value: PositionStack.altitude) {
                        CardView {
                            Image(systemName: RootTab.altitude.symbolImage)
                            Text(RootTab.altitude.stringValue)
                        }
                    }
                    .accessibilityIdentifier(UIIdentifiers.PositionScreen.altitudeButton)
                }
                .frame(maxWidth: 360)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle(RootTab.position.stringValue)
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
