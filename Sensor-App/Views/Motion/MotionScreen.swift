//
//  MotionScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.06.25.
//

import SwiftUI

struct MotionScreen: View {

    @Environment(AppState.self) private var appState

    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 20)
    ]

    // MARK: - Body
    var body: some View {
        NavigationStack(path: Bindable(appState).motionStack) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    NavigationLink(value: MotionStack.acceleration) {
                        CardView {
                            Image(systemName: RootTab.acceleration.symbolImage)
                            Text(RootTab.acceleration.stringValue)
                        }
                    }
                    .accessibilityIdentifier(UIIdentifiers.MotionScreen.accelerationButton)

                    NavigationLink(value: MotionStack.gravity) {
                        CardView {
                            Image(systemName: RootTab.gravity.symbolImage)
                            Text(RootTab.gravity.stringValue)
                        }
                    }
                    .accessibilityIdentifier(UIIdentifiers.MotionScreen.gravityButton)

                    NavigationLink(value: MotionStack.gyroscope) {
                        CardView {
                            Image(systemName: RootTab.gyroscope.symbolImage)
                            Text(RootTab.gyroscope.stringValue)
                        }
                    }
                    .accessibilityIdentifier(UIIdentifiers.MotionScreen.gyroscopeButton)

                    NavigationLink(value: MotionStack.attitude) {
                        CardView {
                            Image(systemName: RootTab.attitude.symbolImage)
                            Text(RootTab.attitude.stringValue)
                        }
                    }
                    .accessibilityIdentifier(UIIdentifiers.MotionScreen.attitudeButton)
                }
                .frame(maxWidth: 360)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle(RootTab.motion.stringValue)
            .navigationSubtitle("Select a motion type")
            .navigationDestination(for: MotionStack.self) { $0 }
        }
    }
}

// MARK: - Preview
#Preview("MotionScreen - English", traits: .navEmbedded) {
    MotionScreen()
        .environment(AppState())
}

#Preview("MotionScreen - German", traits: .navEmbedded) {
    MotionScreen()
        .previewLocalization(.german)
        .environment(AppState())
}
