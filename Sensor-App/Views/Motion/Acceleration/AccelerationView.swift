//
//  AccelerationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct AccelerationView: View {

    @Environment(MotionManager.self) private var motionManager

    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false
    @State private var selectedChart: ChartSelection?

    // MARK: - Body
    var body: some View {
        List {
            Section("Acceleration") {
                DisclosureGroup(
                    isExpanded: $showXAxis,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .accelerationXAxis, title: "X-Axis",
                            selectedChart: $selectedChart)
                    },
                    label: {
                        Text("X-Axis: \(motionManager.motion?.accelerationXAxis ?? 0.0, specifier: "%.5f") m/s^2")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showXAxis)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showXAxis)
                            .accessibilityInputLabels(["Latitude"])
                            .accessibilityIdentifier(UIIdentifiers.AccelerationView.xAxisRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showYAxis,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .accelerationYAxis, title: "Y-Axis",
                            selectedChart: $selectedChart)
                    },
                    label: {
                        Text("Y-Axis: \(motionManager.motion?.accelerationYAxis ?? 0.0, specifier: "%.5f") m/s^2")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showYAxis)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showYAxis)
                            .accessibilityInputLabels(["Latitude"])
                            .accessibilityIdentifier(UIIdentifiers.AccelerationView.yAxisRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showZAxis,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .accelerationZAxis, title: "Z-Axis",
                            selectedChart: $selectedChart)
                    },
                    label: {
                        Text("Z-Axis: \(motionManager.motion?.accelerationZAxis ?? 0.0, specifier: "%.5f") m/s^2")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showZAxis)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showZAxis)
                            .accessibilityInputLabels(["Latitude"])
                            .accessibilityIdentifier(UIIdentifiers.AccelerationView.zAxisRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                NavigationLink(value: MotionStack.accelerationLog) {
                    Text("Log")
                        .accessibilityHint("View Acceleration Log")
                        .accessibilityIdentifier(UIIdentifiers.AccelerationView.logButton)
                }
            }

            #if !DEBUG
                MotionManagerAccessView()
            #endif

            SensorStatisticsSection(axes: [
                AxisEntry(label: "X", stats: motionManager.statistics(for: .accelerationXAxis)),
                AxisEntry(label: "Y", stats: motionManager.statistics(for: .accelerationYAxis)),
                AxisEntry(label: "Z", stats: motionManager.statistics(for: .accelerationZAxis))
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
#Preview("AccelerationView - English", traits: .navEmbedded) {
    AccelerationView()
}

#Preview("AccelerationView - German", traits: .navEmbedded) {
    AccelerationView()
        .previewLocalization(.german)
}
