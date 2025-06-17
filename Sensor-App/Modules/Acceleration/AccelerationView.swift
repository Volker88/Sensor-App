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

    // MARK: - Body
    var body: some View {
        List {
            Section(header: Text("Acceleration", comment: "AccelerationView - Section Header")) {
                DisclosureGroup(
                    isExpanded: $showXAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .accelerationXAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "X-Axis: \(motionManager.motion?.accelerationXAxis ?? 0.0, specifier: "%.5f") m/s^2",
                            comment: "AccelerationView - X-Axis")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.AccelerationView.xAxisRow)

                DisclosureGroup(
                    isExpanded: $showYAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .accelerationYAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Y-Axis: \(motionManager.motion?.accelerationYAxis ?? 0.0, specifier: "%.5f") m/s^2",
                            comment: "AccelerationView - Y-Axis")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.AccelerationView.yAxisRow)

                DisclosureGroup(
                    isExpanded: $showZAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .accelerationZAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Z-Axis: \(motionManager.motion?.accelerationZAxis ?? 0.0, specifier: "%.5f") m/s^2",
                            comment: "AccelerationView - Z-Axis")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.AccelerationView.zAxisRow)

                NavigationLink(value: MotionStack.accelerationLog) {
                    Text("Log", comment: "AccelerationView - Log")
                        .accessibilityIdentifier("Log")
                }
                .accessibilityIdentifier(UIIdentifiers.AccelerationView.logButton)
            }

            #if !DEBUG
                MotionManagerAccessView()
            #endif

            Section(header: Text("Refresh Rate", comment: "AccelerationView - Section Header")) {
                RefreshRateView(show: "header")
                RefreshRateView(show: "slider")
            }
        }
        .listStyle(.insetGrouped)
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
