//
//  GyroscopeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 14.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct GyroscopeView: View {

    @Environment(MotionManager.self) private var motionManager

    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false
    @State private var selectedChart: ChartSelection?

    // MARK: - Body
    var body: some View {
        List {
            Section("Gyroscope") {
                DisclosureGroup(
                    isExpanded: $showXAxis,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .gyroXAxis, title: "X-Axis", selectedChart: $selectedChart)
                    },
                    label: {
                        Text("X-Axis: \(motionManager.motion?.gyroXAxis ?? 0.0, specifier: "%.5f") rad/s")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showXAxis)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showXAxis)
                            .accessibilityInputLabels(["X-Axis"])
                            .accessibilityIdentifier(UIIdentifiers.GyroscopeView.xAxisRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showYAxis,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .gyroYAxis, title: "Y-Axis", selectedChart: $selectedChart)
                    },
                    label: {
                        Text("Y-Axis: \(motionManager.motion?.gyroYAxis ?? 0.0, specifier: "%.5f") rad/s")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showYAxis)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showYAxis)
                            .accessibilityInputLabels(["Y-Axis"])
                            .accessibilityIdentifier(UIIdentifiers.GyroscopeView.yAxisRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showZAxis,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .gyroZAxis, title: "Z-Axis", selectedChart: $selectedChart)
                    },
                    label: {
                        Text("Z-Axis: \(motionManager.motion?.gyroZAxis ?? 0.0, specifier: "%.5f") rad/s")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showZAxis)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showZAxis)
                            .accessibilityInputLabels(["Z-Axis"])
                            .accessibilityIdentifier(UIIdentifiers.GyroscopeView.zAxisRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                NavigationLink(value: MotionStack.gyroscopeLog) {
                    Text("Log")
                        .accessibilityHint("View Gyroscope Log")
                        .accessibilityIdentifier(UIIdentifiers.GyroscopeView.logButton)
                }
            }

            MotionManagerAccessView()

            SensorStatisticsSection(axes: [
                AxisEntry(label: "X", stats: motionManager.statistics(for: .gyroXAxis)),
                AxisEntry(label: "Y", stats: motionManager.statistics(for: .gyroYAxis)),
                AxisEntry(label: "Z", stats: motionManager.statistics(for: .gyroZAxis))
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
#Preview("GyroscopeView - English", traits: .navEmbedded) {
    GyroscopeView()
}

#Preview("GyroscopeView - German", traits: .navEmbedded) {
    GyroscopeView()
        .previewLocalization(.german)
}
