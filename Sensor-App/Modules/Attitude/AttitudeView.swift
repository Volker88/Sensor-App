//
//  AttitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct AttitudeView: View {

    @Environment(MotionManager.self) private var motionManager

    @State private var showRoll = false
    @State private var showPitch = false
    @State private var showYaw = false
    @State private var showHeading = false

    // MARK: - Body
    var body: some View {
        List {
            Section(header: Text("Attitude", comment: "AttitudeView - Section Header")) {
                DisclosureGroup(
                    isExpanded: $showRoll,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .attitudeRoll)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Roll: \((motionManager.motion?.attitudeRoll ?? 0.0) * 180 / .pi, specifier: "%.5f")°",
                            comment: "AttitudeView - Roll")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.AttitudeView.rollRow)

                DisclosureGroup(
                    isExpanded: $showPitch,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .attitudePitch)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Pitch: \((motionManager.motion?.attitudePitch ?? 0.0) * 180 / .pi, specifier: "%.5f")°",
                            comment: "AttitudeView - Pitch")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.AttitudeView.pitchRow)

                DisclosureGroup(
                    isExpanded: $showYaw,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .attitudeYaw)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Yaw: \((motionManager.motion?.attitudeYaw ?? 0.0) * 180 / .pi, specifier: "%.5f")°",
                            comment: "AttitudeView - Yaw")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.AttitudeView.yawRow)

                DisclosureGroup(
                    isExpanded: $showHeading,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .attitudeHeading)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Heading: \(motionManager.motion?.attitudeHeading ?? 0.0, specifier: "%.5f")°",
                            comment: "AttitudeView - Heading")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.AttitudeView.headingRow)

                NavigationLink(value: MotionStack.attitudeLog) {
                    Text("Log", comment: "AttitudeView - Log")
                }
                .accessibilityIdentifier(UIIdentifiers.AttitudeView.logButton)
            }

            MotionManagerAccessView()

            Section(header: Text("Refresh Rate", comment: "AccelerationView - Section Header")) {
                RefreshRateView(show: "header")
                RefreshRateView(show: "slider")
            }
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - Preview
#Preview("AttitudeView - English", traits: .navEmbedded) {
    AttitudeView()
}

#Preview("AttitudeView - German", traits: .navEmbedded) {
    AttitudeView()
        .previewLocalization(.german)
}
