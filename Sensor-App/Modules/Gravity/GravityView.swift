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

    // MARK: - Body
    var body: some View {
        List {
            Section(header: Text("Gravity", comment: "GravityView - Section Header")) {
                DisclosureGroup(
                    isExpanded: $showXAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .gravityXAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "X-Axis: \(motionManager.motion?.gravityXAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)",
                            comment: "GravityView - X-Axis")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.GravityView.xAxisRow)

                DisclosureGroup(
                    isExpanded: $showYAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .gravityYAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Y-Axis: \(motionManager.motion?.gravityYAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)",
                            comment: "GravityView - Y-Axis")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.GravityView.yAxisRow)

                DisclosureGroup(
                    isExpanded: $showZAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .gravityZAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Z-Axis: \(motionManager.motion?.gravityZAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)",
                            comment: "GravityView - Z-Axis")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.GravityView.zAxisRow)

                NavigationLink(value: MotionStack.gravityLog) {
                    Text("Log", comment: "GravityView - Log")
                }
                .accessibilityIdentifier(UIIdentifiers.GravityView.logButton)
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
#Preview("GravityView - English", traits: .navEmbedded) {
    GravityView()
}

#Preview("GravityView - German", traits: .navEmbedded) {
    GravityView()
        .previewLocalization(.german)
}
