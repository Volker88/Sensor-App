//
//  MagnetometerScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct MagnetometerScreen: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        MagnetometerView()
            .toolbar {
                CustomToolbar()
            }
            .navigationTitle(NSLocalizedString("Magnetometer", comment: "NavigationBar Title - Magnetometer"))
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                    case .magnetometerList:
                        MagnetometerList()
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
#Preview {
    MagnetometerScreen()
        .previewNavigationStackWrapper()
}
