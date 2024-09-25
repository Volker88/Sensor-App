//
//  GyroscopeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct GyroscopeScreen: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        GyroscopeView()
            .toolbar {
                CustomToolbar()
            }
            .navigationTitle(NSLocalizedString("Gyroscope", comment: "NavigationBar Title - Gyroscope"))
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                    case .gyroscopeList:
                        GyroscopeList()
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
    GyroscopeScreen()
        .previewNavigationStackWrapper()
}
