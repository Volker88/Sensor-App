//
//  GyroscopeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import Sensor_App_Framework
import SwiftUI

struct GyroscopeScreen: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        GyroscopeView()
            .toolbar {
                CustomToolbar()
            }
            .navigationTitle(Text("Gyroscope", comment: "NavigationBar Title - Gyroscope sensor screen"))
            .navigationDestination(
                for: Route.self,
                destination: { route in
                    switch route {
                        case .gyroscopeList:
                            GyroscopeList()
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
#Preview("GyroscopeScreen - English", traits: .navEmbedded) {
    GyroscopeScreen()
}

#Preview("GyroscopeScreen - German", traits: .navEmbedded) {
    GyroscopeScreen()
        .previewLocalization(.german)
}
