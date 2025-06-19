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
            Section("Gyroscope") {
                DisclosureGroup(
                    isExpanded: $showXAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .gyroXAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text("X-Axis: \(motionManager.motion?.gyroXAxis ?? 0.0, specifier: "%.5f") rad/s")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.GyroscopeView.xAxisRow)

                DisclosureGroup(
                    isExpanded: $showYAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .gyroYAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text("Y-Axis: \(motionManager.motion?.gyroYAxis ?? 0.0, specifier: "%.5f") rad/s")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.GyroscopeView.yAxisRow)

                DisclosureGroup(
                    isExpanded: $showZAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .gyroZAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text("Z-Axis: \(motionManager.motion?.gyroZAxis ?? 0.0, specifier: "%.5f") rad/s")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.GyroscopeView.zAxisRow)

                NavigationLink(value: MotionStack.gyroscopeLog) {
                    Text("Log")
                }
                .accessibilityIdentifier(UIIdentifiers.GyroscopeView.logButton)
            }

            MotionManagerAccessView()

            Section("Refresh Rate") {
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
