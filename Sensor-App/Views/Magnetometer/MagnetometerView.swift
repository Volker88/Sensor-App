//
//  MagnetometerView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct MagnetometerView: View {

    @Environment(MotionManager.self) private var motionManager

    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false
    @State private var selectedChart: ChartSelection?

    // MARK: - Body
    var body: some View {
        List {
            Section("Magnetometer") {
                DisclosureGroup(
                    isExpanded: $showXAxis,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .magnetometerXAxis, title: "X-Axis",
                            selectedChart: $selectedChart)
                    },
                    label: {
                        Text("X-Axis: \(motionManager.motion?.magnetometerXAxis ?? 0.0, specifier: "%.5f") µT")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showXAxis)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showXAxis)
                            .accessibilityInputLabels(["X-Axis"])
                            .accessibilityIdentifier(UIIdentifiers.MagnetometerView.xAxisRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showYAxis,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .magnetometerYAxis, title: "Y-Axis",
                            selectedChart: $selectedChart)
                    },
                    label: {
                        Text("Y-Axis: \(motionManager.motion?.magnetometerYAxis ?? 0.0, specifier: "%.5f") µT")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showYAxis)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showYAxis)
                            .accessibilityInputLabels(["Y-Axis"])
                            .accessibilityIdentifier(UIIdentifiers.MagnetometerView.yAxisRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showZAxis,
                    content: {
                        ExpandableChartView(
                            graph: .motion, showGraph: .magnetometerZAxis, title: "Z-Axis",
                            selectedChart: $selectedChart)
                    },
                    label: {
                        Text("Z-Axis: \(motionManager.motion?.magnetometerZAxis ?? 0.0, specifier: "%.5f") µT")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showZAxis)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showZAxis)
                            .accessibilityInputLabels(["Z-Axis"])
                            .accessibilityIdentifier(UIIdentifiers.MagnetometerView.zAxisRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                NavigationLink(value: MagnetometerStack.magnetometerLog) {
                    Text("Log")
                        .accessibilityHint("View Magnetometer Log")
                        .accessibilityIdentifier(UIIdentifiers.MagnetometerView.logButton)
                }
            }

            MotionManagerAccessView()

            SensorStatisticsSection(axes: [
                AxisEntry(label: "X", stats: motionManager.statistics(for: .magnetometerXAxis)),
                AxisEntry(label: "Y", stats: motionManager.statistics(for: .magnetometerYAxis)),
                AxisEntry(label: "Z", stats: motionManager.statistics(for: .magnetometerZAxis))
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
#Preview("MagnetometerView - English", traits: .navEmbedded) {
    MagnetometerView()
}

#Preview("MagnetometerView - German", traits: .navEmbedded) {
    MagnetometerView()
        .previewLocalization(.german)
}
