//
//  AccelerationScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AccelerationScreen: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        AccelerationView()
            .toolbar {
                CustomToolbar()
            }
            .navigationTitle(NSLocalizedString("Acceleration", comment: "NavigationBar Title - Acceleration"))
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                    case .accelerationList:
                        AccelerationList()
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
    AccelerationScreen()
        .previewNavigationStackWrapper()
}
