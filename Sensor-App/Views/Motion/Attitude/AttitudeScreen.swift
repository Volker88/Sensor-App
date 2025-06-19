//
//  AttitudeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import Sensor_App_Framework
import SwiftUI

struct AttitudeScreen: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        AttitudeView()
            .safeAreaInset(edge: .bottom) {
                CustomControlsView()
            }
            .navigationTitle("Attitude")
            .onAppear {
                motionManager.startMotionUpdates()
            }
    }
}

// MARK: - Preview
#Preview("AttitudeScreen - English", traits: .navEmbedded) {
    AttitudeScreen()
}

#Preview("AttitudeScreen - German", traits: .navEmbedded) {
    AttitudeScreen()
        .previewLocalization(.german)
}
