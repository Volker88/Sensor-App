//
//  AltitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct AltitudeView: View {

    @Environment(MotionManager.self) private var motionManager

    @State private var showPressure = false
    @State private var showRelativeAltitudeChange = false

    // MARK: - Body
    var body: some View {
        List {
            Section("Altitude") {
                DisclosureGroup(
                    isExpanded: $showPressure,
                    content: {
                        LineGraphSubView(graph: .altitude, showGraph: .pressureValue)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Pressure: \(motionManager.altitude?.calculatedPressure ?? 0.0, specifier: "%.5f") \(motionManager.altitude?.pressureUnit ?? "")"
                        )
                        .accessibilityHint("Tap to collapse graph", isEnabled: showPressure)
                        .accessibilityHint("Tap to expand  graph", isEnabled: !showPressure)
                        .accessibilityInputLabels(["Pressure"])
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)
                .accessibilityIdentifier(UIIdentifiers.AltitudeView.pressureRow)

                DisclosureGroup(
                    isExpanded: $showRelativeAltitudeChange,
                    content: {
                        LineGraphSubView(graph: .altitude, showGraph: .relativeAltitudeValue)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Altitude change: \(motionManager.altitude?.calculatedAltitude ?? 0.0, specifier: "%.5f") \(motionManager.altitude?.altitudeUnit ?? "")"
                        )
                        .accessibilityHint("Tap to collapse graph", isEnabled: showRelativeAltitudeChange)
                        .accessibilityHint("Tap to expand  graph", isEnabled: !showRelativeAltitudeChange)
                        .accessibilityInputLabels(["Altitude change"])
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)
                .accessibilityIdentifier(UIIdentifiers.AltitudeView.altitudeRow)

                NavigationLink(value: PositionStack.altitudeLog) {
                    Text("Log")
                        .accessibilityHint("View Altitude Log")
                }
                .accessibilityIdentifier(UIIdentifiers.AltitudeView.logButton)
            }

            MotionManagerAccessView()
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - Preview
#Preview("AltitudeView - English", traits: .navEmbedded) {
    AltitudeView()
}

#Preview("AltitudeView - German", traits: .navEmbedded) {
    AltitudeView()
        .previewLocalization(.german)
}
