//
//  MagnetometerScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import Sensor_App_Framework
import SwiftUI

struct MagnetometerScreen: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        MagnetometerView()
            .toolbar {
                CustomToolbar()
            }
            .navigationTitle(Text("Magnetometer", comment: "NavigationBar Title - Magnetometer sensor screen"))
            .navigationDestination(
                for: Route.self,
                destination: { route in
                    switch route {
                        case .magnetometerList:
                            MagnetometerList()
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
#Preview("MagnetometerScreen - English", traits: .navEmbedded) {
    MagnetometerScreen()
}

#Preview("MagnetometerScreen - German", traits: .navEmbedded) {
    MagnetometerScreen()
        .previewLocalization(.german)
}
