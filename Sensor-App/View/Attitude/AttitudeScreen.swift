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
            .navigationTitle(NSLocalizedString("Attitude", comment: "NavigationBar Title - Attitude"))
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
#Preview {
    AttitudeScreen()
        .previewNavigationStackWrapper()
}
