//
//  GravityScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct GravityScreen: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        GravityView()
            .toolbar {
                CustomToolbar()
            }
            .navigationTitle(Text("Gravity", comment: "NavigationBar Title - Gravity"))
            .navigationDestination(
                for: Route.self,
                destination: { route in
                    switch route {
                        case .gravityList:
                            GravityList()
                        default:
                            EmptyView()
                    }
                }
            )
            .onAppear {
                motionManager.startMotionUpdates()
            }
    }
}

// MARK: - Preview
#Preview("GravityScreen - English", traits: .navEmbedded) {
    GravityScreen()
}

#Preview("GravityScreen - German", traits: .navEmbedded) {
    GravityScreen()
        .previewLocalization(.german)
}
