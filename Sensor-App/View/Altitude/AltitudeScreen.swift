//
//  AltitudeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AltitudeScreen: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        AltitudeView()
            .toolbar {
                CustomToolbar()
            }
            .navigationTitle(NSLocalizedString("Altitude", comment: "NavigationBar Title - Altitude"))
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                    case .altitudeList:
                        AltitudeList()
                    default:
                        EmptyView()
                }
            })
            .onAppear {
                motionManager.startAltitudeUpdates()
            }
    }
}

// MARK: - Preview
#Preview {
    AltitudeScreen()
        .previewNavigationStackWrapper()
}
