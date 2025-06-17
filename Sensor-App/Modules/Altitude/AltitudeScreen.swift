//
//  AltitudeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import Sensor_App_Framework
import SwiftUI

struct AltitudeScreen: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        AltitudeView()
            .safeAreaInset(edge: .bottom) {
                CustomControlsView()
            }
            .navigationTitle(Text("Altitude", comment: "NavigationBar Title - Altitude sensor screen"))
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
