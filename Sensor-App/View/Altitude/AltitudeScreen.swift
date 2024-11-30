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
            .navigationTitle(Text("Altitude", comment: "NavigationBar Title - Altitude sensor screen"))
            .navigationDestination(
                for: Route.self,
                destination: { route in
                    switch route {
                        case .altitudeList:
                            AltitudeList()
                        default:
                            EmptyView()
                    }
                }
            )
            .onAppear {
                motionManager.startAltitudeUpdates()
            }
    }
}

// MARK: - Preview
#Preview("AltitudeScreen - English", traits: .navEmbedded) {
    AltitudeScreen()
}

#Preview("AltitudeScreen - German", traits: .navEmbedded) {
    AltitudeScreen()
        .previewLocalization(.german)
}
