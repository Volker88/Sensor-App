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
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)
                .accessibilityIdentifier(UIIdentifiers.MagnetometerView.xAxisRow)

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
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)
                .accessibilityIdentifier(UIIdentifiers.MagnetometerView.yAxisRow)

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
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)
                .accessibilityIdentifier(UIIdentifiers.MagnetometerView.zAxisRow)

                NavigationLink(value: MagnetometerStack.magnetometerLog) {
                    Text("Log")
                        .accessibilityHint("View Magnetometer Log")
                }
                .accessibilityIdentifier(UIIdentifiers.MagnetometerView.logButton)
            }

            MotionManagerAccessView()

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
