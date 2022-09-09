//
//  AltitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct AltitudeView: View {
    let calculationAPI = CalculationAPI()
    let exportAPI = ExportAPI()

    @EnvironmentObject var settings: SettingsAPI
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject var motionVM: CoreMotionViewModel
    @State private var showPressure = false
    @State private var showRelativeAltitudeChange = false

    var body: some View {
        GeometryReader { geo in
            List {
                Section(header: Text("Acceleration", comment: "AccelerationView - Section Header")) {
                    DisclosureGroup(
                        isExpanded: $showPressure,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .altitude, showGraph: .pressureValue)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Pressure: \(calculationAPI.calculatePressure(pressure: motionVM.altitudeArray.last?.pressureValue ?? 0.0, to: settings.fetchUserSettings().pressureSetting), specifier: "%.5f") \(settings.fetchUserSettings().pressureSetting)", comment: "AltitudeView - Pressure") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Pressure Graph")

                    DisclosureGroup(
                        isExpanded: $showRelativeAltitudeChange,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .altitude, showGraph: .relativeAltitudeValue)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Altitude change: \(calculationAPI.calculateHeight(height: motionVM.altitudeArray.last?.relativeAltitudeValue ?? 0.0, to: settings.fetchUserSettings().altitudeHeightSetting), specifier: "%.5f") \(settings.fetchUserSettings().altitudeHeightSetting)", comment: "AltitudeView - Altitude") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Altitude Graph")

                    NavigationLink(value: Route.altitudeList) {
                        Text("Log", comment: "AltitudeView - Log")
                    }
                }

                Section(header: Text("Refresh Rate", comment: "AltitudeView - Section Header")) {
                    RefreshRateView(motionVM: motionVM, show: "header")
                    RefreshRateView(motionVM: motionVM, show: "slider")
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

struct AltitudeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AltitudeView()
        }
    }
}
