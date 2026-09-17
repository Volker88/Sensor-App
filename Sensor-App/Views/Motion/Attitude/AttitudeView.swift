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
            Section("Attitude") {
                DisclosureGroup(
                    isExpanded: $showRoll,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .attitudeRoll, title: "Roll")
                    },
                    label: {
                        Text("Roll: \((motionManager.motion?.attitudeRoll ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showRoll)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showRoll)
                            .accessibilityInputLabels(["Roll"])
                            .accessibilityIdentifier(UIIdentifiers.AttitudeView.rollRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showPitch,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .attitudePitch, title: "Pitch")
                    },
                    label: {
                        Text("Pitch: \((motionManager.motion?.attitudePitch ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showPitch)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showPitch)
                            .accessibilityInputLabels(["Pitch"])
                            .accessibilityIdentifier(UIIdentifiers.AttitudeView.pitchRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showYaw,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .attitudeYaw, title: "Yaw")
                    },
                    label: {
                        Text("Yaw: \((motionManager.motion?.attitudeYaw ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showYaw)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showYaw)
                            .accessibilityInputLabels(["Yaw"])
                            .accessibilityIdentifier(UIIdentifiers.AttitudeView.yawRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showHeading,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .attitudeHeading, title: "Heading"
                        )
                    },
                    label: {
                        Text("Heading: \(motionManager.motion?.attitudeHeading ?? 0.0, specifier: "%.5f")°")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showHeading)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showHeading)
                            .accessibilityInputLabels(["Heading"])
                            .accessibilityIdentifier(UIIdentifiers.AttitudeView.headingRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                NavigationLink(value: NavigationRoute.motion(.attitudeLog)) {
                    Text("Log")
                        .accessibilityHint("View Attitude Log")
                        .accessibilityIdentifier(UIIdentifiers.AttitudeView.logButton)
                }
            }

            MotionManagerAccessView()

            SensorStatisticsSection(axes: [
                AxisEntry(label: "Roll", stats: motionManager.statistics(for: .attitudeRoll)),
                AxisEntry(label: "Pitch", stats: motionManager.statistics(for: .attitudePitch)),
                AxisEntry(label: "Yaw", stats: motionManager.statistics(for: .attitudeYaw)),
                AxisEntry(label: "Heading", stats: motionManager.statistics(for: .attitudeHeading))
            ])

            Section("Refresh Rate") {
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
