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
                            Text("Acceleration")
                        }
                    }

                    NavigationLink(value: MotionStack.gravity) {
                        CardView {
                            Text("Gravity")
                        }
                    }

                    NavigationLink(value: MotionStack.gyroscope) {
                        CardView {
                            Text("Gyroscope")
                        }
                    }

                    NavigationLink(value: MotionStack.attitude) {
                        CardView {
                            Text("Attitude")
                        }
                    }
                }
                .frame(maxWidth: 360)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Motion")
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
