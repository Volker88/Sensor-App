//
//  AttitudeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AttitudeScreen: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        AttitudeView()
            .toolbar {
                CustomToolbar()
            }
            .navigationTitle(Text("Attitude", comment: "NavigationBar Title - Attitude sensor screen"))
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                    case .attitudeList:
                        AttitudeList()
                    default:
                        EmptyView()

                }
            })
            .onAppear {
                motionManager.startMotionUpdates()
            }
    }
}

// MARK: - Preview
#Preview("AttitudeScreen - English", traits: .navEmbedded) {
    AttitudeScreen()
}

#Preview("AttitudeScreen - German", traits: .navEmbedded) {
    AttitudeScreen()
        .previewLocalization(.german)
}
