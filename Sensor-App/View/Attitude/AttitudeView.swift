//
//  AttitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct AttitudeView: View {
    let exportAPI = ExportAPI()

    @EnvironmentObject var settings: SettingsAPI
    @EnvironmentObject var motionVM: CoreMotionViewModel
    @State private var showRoll = false
    @State private var showPitch = false
    @State private var showYaw = false
    @State private var showHeading = false

    var body: some View {
        GeometryReader { geo in
            List {
                Section(header: Text("Attitude", comment: "AttitudeView - Section Header")) {
                    DisclosureGroup(
                        isExpanded: $showRoll,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .attitudeRoll)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Roll: \((motionVM.coreMotionArray.last?.attitudeRoll ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Roll") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Roll Graph")

                    DisclosureGroup(
                        isExpanded: $showPitch,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .attitudePitch)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Pitch: \((motionVM.coreMotionArray.last?.attitudePitch ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Pitch") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Pitch Graph")

                    DisclosureGroup(
                        isExpanded: $showYaw,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .attitudeYaw)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Yaw: \((motionVM.coreMotionArray.last?.attitudeYaw ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Yaw") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Yaw Graph")

                    DisclosureGroup(
                        isExpanded: $showHeading,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .attitudeHeading)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Heading: \(motionVM.coreMotionArray.last?.attitudeHeading ?? 0.0, specifier: "%.5f")°", comment: "AttitudeView - Heading") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Heading Graph")

                    NavigationLink(value: Route.attitudeList) {
                        Text("Log", comment: "AttitudeView - Log")
                    }
                }

                Section(header: Text("Refresh Rate", comment: "AccelerationView - Section Header")) {
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

struct AttitudeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AttitudeView()
        }
    }
}
