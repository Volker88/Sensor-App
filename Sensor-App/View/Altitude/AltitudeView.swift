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
    @Environment(SettingsManager.self) private var settingsManager
    @Environment(CalculationManager.self) private var calculationManager

    @State private var showPressure = false
    @State private var showRelativeAltitudeChange = false

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in // TODO: - Remove GeometryReader
            List {
                Section(header: Text("Altitude", comment: "AltitudeView - Section Header")) {
                    DisclosureGroup(
                        isExpanded: $showPressure,
                        content: {
                            LineGraphSubView(graph: .altitude, showGraph: .pressureValue)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Pressure: \(calculationManager.calculatePressure(pressure: motionManager.altitude?.pressureValue ?? 0.0, to: settingsManager.fetchUserSettings().pressureSetting), specifier: "%.5f") \(settingsManager.fetchUserSettings().pressureSetting)", comment: "AltitudeView - Pressure")
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Pressure Graph")

                    DisclosureGroup(
                        isExpanded: $showRelativeAltitudeChange,
                        content: {
                            LineGraphSubView(graph: .altitude, showGraph: .relativeAltitudeValue)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Altitude change: \(calculationManager.calculateHeight(height: motionManager.altitude?.relativeAltitudeValue ?? 0.0, to: settingsManager.fetchUserSettings().altitudeHeightSetting), specifier: "%.5f") \(settingsManager.fetchUserSettings().altitudeHeightSetting)", comment: "AltitudeView - Altitude")
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Altitude Graph")

                    NavigationLink(value: Route.altitudeList) {
                        Text("Log", comment: "AltitudeView - Log")
                    }
                }

                Section(header: Text("Refresh Rate", comment: "AltitudeView - Section Header")) {
                    RefreshRateView(show: "header")
                    RefreshRateView(show: "slider")
                }
            }
            .listStyle(.insetGrouped)
            .frame(
                minWidth: 0,
                idealWidth: geo.size.width,
                maxWidth: .infinity,
                minHeight: 0,
                idealHeight: geo.size.height,
                maxHeight: geo.size.height,
                alignment: .leading
            )
        }
    }
}

// MARK: - Preview
#Preview {
    AltitudeView()
        .previewNavigationStackWrapper()
}
