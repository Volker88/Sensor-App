//
//  AltitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct AltitudeView: View {

    @Environment(MotionManager.self) private var motionManager

    @State private var showPressure = false
    @State private var showRelativeAltitudeChange = false

    // MARK: - Body
    var body: some View {
        List {
            Section(header: Text("Altitude", comment: "AltitudeView - Section Header")) {
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
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle Pressure Graph")

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
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle Altitude Graph")

                NavigationLink(value: Route.altitudeList) {
                    Text("Log", comment: "AltitudeView - Log")
                        .accessibilityIdentifier("Log")
                }
            }
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
