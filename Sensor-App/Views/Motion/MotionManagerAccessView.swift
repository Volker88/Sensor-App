//
//  MotionManagerAccessView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 1/14/25.
//

import Sensor_App_Framework
import SwiftUI

struct MotionManagerAccessView: View {

    @Environment(MotionManager.self) private var motionManager

    var body: some View {
        Group {
            if motionManager.authorizationStatus != .authorized {
                HStack {
                    Spacer()

                    VStack {
                        Text("Access to Motion Sensor is required")
                            .foregroundColor(.red)

                        Button {
                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettings)
                            }
                        } label: {
                            Text("Open Settings")
                        }
                    }

                    Spacer()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview("MotionManagerAccessView - English", traits: .navEmbedded) {
    MotionManagerAccessView()
}

#Preview("MotionManagerAccessView - German", traits: .navEmbedded) {
    MotionManagerAccessView()
        .previewLocalization(.german)
}
