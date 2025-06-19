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

    // MARK: - Body
    var body: some View {
        List {
            Section("Magnetometer") {
                DisclosureGroup(
                    isExpanded: $showXAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .magnetometerXAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text("X-Axis: \(motionManager.motion?.magnetometerXAxis ?? 0.0, specifier: "%.5f") µT")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.MagnetometerView.xAxisRow)

                DisclosureGroup(
                    isExpanded: $showYAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .magnetometerYAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text("Y-Axis: \(motionManager.motion?.magnetometerYAxis ?? 0.0, specifier: "%.5f") µT")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.MagnetometerView.yAxisRow)

                DisclosureGroup(
                    isExpanded: $showZAxis,
                    content: {
                        LineGraphSubView(graph: .motion, showGraph: .magnetometerZAxis)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text("Z-Axis: \(motionManager.motion?.magnetometerZAxis ?? 0.0, specifier: "%.5f") µT")
                    }
                )
                .accessibilityIdentifier(UIIdentifiers.MagnetometerView.zAxisRow)

                NavigationLink(value: MagnetometerStack.magnetometerLog) {
                    Text("Log")
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
