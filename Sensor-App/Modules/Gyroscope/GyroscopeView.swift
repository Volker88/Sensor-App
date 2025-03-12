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

    // MARK: - Body
    var body: some View {
        List {
            Section(header: Text("Gyroscope", comment: "GyroscopeView - Section Header")) {
                DisclosureGroup(
                    isExpanded: $showXAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .gyroXAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "X-Axis: \(motionManager.motion?.gyroXAxis ?? 0.0, specifier: "%.5f") rad/s",
                            comment: "GyroscopeView - X-Axis")
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle X-Axis Graph")

                DisclosureGroup(
                    isExpanded: $showYAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .gyroYAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Y-Axis: \(motionManager.motion?.gyroYAxis ?? 0.0, specifier: "%.5f") rad/s",
                            comment: "GyroscopeView - Y-Axis")
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle Y-Axis Graph")

                DisclosureGroup(
                    isExpanded: $showZAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .gyroZAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Z-Axis: \(motionManager.motion?.gyroZAxis ?? 0.0, specifier: "%.5f") rad/s",
                            comment: "GyroscopeView - Z-Axis")
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle Z-Axis Graph")

                NavigationLink(value: Route.gyroscopeList) {
                    Text("Log", comment: "GyroscopeView - Log")
                        .accessibilityIdentifier("Log")
                }
            }

            MotionManagerAccessView()

            Section(header: Text("Refresh Rate", comment: "GyroscopeView - Section Header")) {
                RefreshRateView(show: "header")
                RefreshRateView(show: "slider")
            }
        }
        .listStyle(.insetGrouped)
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
