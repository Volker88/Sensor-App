//
//  MagnetometerView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct MagnetometerView: View {

    @Environment(MotionManager.self) private var motionManager

    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false

    // MARK: - Body
    var body: some View {
        List {
            Section(header: Text("Acceleration", comment: "AccelerationView - Section Header")) {
                DisclosureGroup(
                    isExpanded: $showXAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .magnetometerXAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "X-Axis: \(motionManager.motion?.magnetometerXAxis ?? 0.0, specifier: "%.5f") µT",
                            comment: "MagnetometerView - X-Axis")
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle X-Axis Graph")

                DisclosureGroup(
                    isExpanded: $showYAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .magnetometerYAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Y-Axis: \(motionManager.motion?.magnetometerYAxis ?? 0.0, specifier: "%.5f") µT",
                            comment: "MagnetometerView - Y-Axis")
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle Y-Axis Graph")

                DisclosureGroup(
                    isExpanded: $showZAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .magnetometerZAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Z-Axis: \(motionManager.motion?.magnetometerZAxis ?? 0.0, specifier: "%.5f") µT",
                            comment: "MagnetometerView - Z-Axis")
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle Z-Axis Graph")

                NavigationLink(value: Route.magnetometerList) {
                    Text("Log", comment: "MagnetometerView - Log")
                        .accessibilityIdentifier("Log")
                }
            }

            Section(header: Text("Refresh Rate", comment: "MagnetometerView - Section Header")) {
                RefreshRateView(show: "header")
                RefreshRateView(show: "slider")
            }
        }
        .listStyle(.insetGrouped)
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
