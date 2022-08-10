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
    let settings = SettingsAPI()
    let exportAPI = ExportAPI()

    @ObservedObject var motionVM = CoreMotionViewModel()
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
                }

                Section(header: Text("Log", comment: "AccelerationView - Section Header"),
                        footer: ShareSheet(url: shareCSV())
                ) {
                    AltitudeList(motionVM: motionVM)
                        .frame(height: 200, alignment: .center)
                }
            }
            .listStyle(InsetGroupedListStyle())
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
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    func shareCSV() -> URL {
        motionVM.stopMotionUpdates()
        var csvText = NSLocalizedString("ID;Time;Pressure;Altitude change", comment: "Export CSV Headline - altitude") + "\n" // swiftlint:disable:this line_length

        _ = motionVM.altitudeArray.map {
            csvText += "\($0.counter);\($0.timestamp);\(calculationAPI.calculatePressure(pressure: $0.pressureValue, to: settings.fetchUserSettings().pressureSetting).localizedDecimal());\(calculationAPI.calculateHeight(height: $0.relativeAltitudeValue, to: settings.fetchUserSettings().altitudeHeightSetting).localizedDecimal())\n" // swiftlint:disable:this line_length
        }
        return exportAPI.getFile(exportText: csvText, filename: "altitude")
    }

    func onAppear() {
        // Start updating motion
        motionVM.altitudeUpdateStart()
        motionVM.sensorUpdateInterval = settings.fetchUserSettings().frequencySetting
    }

    func onDisappear() {
        motionVM.stopMotionUpdates()
        motionVM.coreMotionArray.removeAll()
        motionVM.altitudeArray.removeAll()
    }
}

struct AltitudeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AltitudeView()
        }
    }
}
