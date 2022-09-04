//
//  GravityView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct GravityView: View {
    let exportAPI = ExportAPI()

    @EnvironmentObject var settings: SettingsAPI
    @EnvironmentObject var motionVM: CoreMotionViewModel
    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false

    var body: some View {
        GeometryReader { geo in
            List {
                Section(header: Text("Gravity", comment: "GravityView - Section Header")) {
                    DisclosureGroup(
                        isExpanded: $showXAxis,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .gravityXAxis)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("X-Axis: \(motionVM.coreMotionArray.last?.gravityXAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - X-Axis") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle X-Axis Graph")

                    DisclosureGroup(
                        isExpanded: $showYAxis,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .gravityYAxis)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Y-Axis: \(motionVM.coreMotionArray.last?.gravityYAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - Y-Axis") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Y-Axis Graph")

                    DisclosureGroup(
                        isExpanded: $showZAxis,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .gravityZAxis)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Z-Axis: \(motionVM.coreMotionArray.last?.gravityZAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - Z-Axis") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Z-Axis Graph")

                }

                Section(
                    header: Text("Log", comment: "AccelerationView - Section Header"),
                    footer: ShareSheet(url: shareCSV())
                ) {
                    GravityList(motionVM: motionVM)
                        .frame(height: 200, alignment: .center)
                }

                Section(header: Text("Refresh Rate", comment: "AccelerationView - Section Header")) {
                    RefreshRateView(motionVM: motionVM, show: "header")
                    RefreshRateView(motionVM: motionVM, show: "slider")
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
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Gravity") + "\n"

        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.gravityXAxis.localizedDecimal());\($0.gravityYAxis.localizedDecimal());\($0.gravityZAxis.localizedDecimal())\n" // swiftlint:disable:this line_length
        }
        return exportAPI.getFile(exportText: csvText, filename: "gravity")
    }

    func onAppear() {
        // Start updating motion
        motionVM.motionUpdateStart()
        motionVM.sensorUpdateInterval = settings.fetchUserSettings().frequencySetting
    }

    func onDisappear() {
        motionVM.stopMotionUpdates()
        motionVM.coreMotionArray.removeAll()
    }
}

struct GravityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GravityView()
        }
    }
}
