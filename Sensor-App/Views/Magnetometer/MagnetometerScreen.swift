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
            .safeAreaInset(edge: .bottom) {
                Color.clear
                    .frame(height: 175)
            }
            .overlay(alignment: .bottom) {
                CustomControlsView()
            }
            .navigationTitle("Magnetometer")
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
