//
//  GravityView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct GravityView: View {

    @Environment(MotionManager.self) private var motionManager

    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false
    @State private var selectedChart: ChartSelection?

    // MARK: - Body
    var body: some View {
        List {
            Section("Gravity") {
                DisclosureGroup(
                    isExpanded: $showXAxis,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .gravityXAxis, title: "X-Axis", selectedChart: $selectedChart)
                    },
                    label: {
                        Text("X-Axis: \(motionManager.motion?.gravityXAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showXAxis)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showXAxis)
                            .accessibilityInputLabels(["X-Axis"])
                            .accessibilityIdentifier(UIIdentifiers.GravityView.xAxisRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showYAxis,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .gravityYAxis, title: "Y-Axis", selectedChart: $selectedChart)
                    },
                    label: {
                        Text("Y-Axis: \(motionManager.motion?.gravityYAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showYAxis)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showYAxis)
                            .accessibilityInputLabels(["Y-Axis"])
                            .accessibilityIdentifier(UIIdentifiers.GravityView.yAxisRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showZAxis,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .gravityZAxis, title: "Z-Axis", selectedChart: $selectedChart)
                    },
                    label: {
                        Text("Z-Axis: \(motionManager.motion?.gravityZAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showZAxis)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showZAxis)
                            .accessibilityInputLabels(["Z-Axis"])
                            .accessibilityIdentifier(UIIdentifiers.GravityView.zAxisRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                NavigationLink(value: MotionStack.gravityLog) {
                    Text("Log")
                        .accessibilityHint("View Gravity Log")
                        .accessibilityIdentifier(UIIdentifiers.GravityView.logButton)
                }

            }

            MotionManagerAccessView()

            SensorStatisticsSection(axes: [
                AxisEntry(label: "X", stats: motionManager.statistics(for: .gravityXAxis)),
                AxisEntry(label: "Y", stats: motionManager.statistics(for: .gravityYAxis)),
                AxisEntry(label: "Z", stats: motionManager.statistics(for: .gravityZAxis))
            ])

            Section("Refresh Rate") {
                RefreshRateView(show: "header")
                RefreshRateView(show: "slider")
            }
        }
        .listStyle(.insetGrouped)
        .fullScreenCover(item: $selectedChart) { selection in
            FullScreenChartView(selection: selection)
        }
    }
}

// MARK: - Preview
#Preview("GravityView - English", traits: .navEmbedded) {
    GravityView()
}

#Preview("GravityView - German", traits: .navEmbedded) {
    GravityView()
        .previewLocalization(.german)
}
