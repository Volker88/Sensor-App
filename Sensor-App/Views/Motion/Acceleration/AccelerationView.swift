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
            Section("Acceleration") {
                DisclosureGroup(
                    isExpanded: $showXAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .accelerationXAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text("X-Axis: \(motionManager.motion?.accelerationXAxis ?? 0.0, specifier: "%.5f") m/s^2")
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
                        Text("Y-Axis: \(motionManager.motion?.accelerationYAxis ?? 0.0, specifier: "%.5f") m/s^2")
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
                        Text("Z-Axis: \(motionManager.motion?.accelerationZAxis ?? 0.0, specifier: "%.5f") m/s^2")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.AccelerationView.zAxisRow)

                NavigationLink(value: MotionStack.accelerationLog) {
                    Text("Log")
                        .accessibilityIdentifier("Log")
                }
                .accessibilityIdentifier(UIIdentifiers.AccelerationView.logButton)
            }

            #if !DEBUG
                MotionManagerAccessView()
            #endif

            Section("Refresh Rate") {
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
