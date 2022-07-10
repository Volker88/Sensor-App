//
//  AttitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct AttitudeView: View {
    let settings = SettingsAPI()
    let exportAPI = ExportAPI()

    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var showShareSheet = false
    @State private var fileToShare: URL?
    @State private var showRoll = false
    @State private var showPitch = false
    @State private var showYaw = false
    @State private var showHeading = false

    var shareButton: some View {
        Button(action: {
            shareCSV()
        }) {
            Label(NSLocalizedString("Export", comment: "AccelerationView - Export List"), systemImage: "square.and.arrow.up") // swiftlint:disable:this line_length
        }
    }

    var body: some View {
        GeometryReader { geo in
            List {
                Section(header: Text("Attitude", comment: "AttitudeView - Section Header")) {
                    DisclosureGroup(
                        isExpanded: $showRoll,
                        content: {
                            LineGraphSubView(motionVM: motionVM, showGraph: .attitudeRoll)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Roll: \((motionVM.coreMotionArray.last?.attitudeRoll ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Roll") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Roll Graph")

                    DisclosureGroup(
                        isExpanded: $showPitch,
                        content: {
                            LineGraphSubView(motionVM: motionVM, showGraph: .attitudePitch)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Pitch: \((motionVM.coreMotionArray.last?.attitudePitch ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Pitch") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Pitch Graph")

                    DisclosureGroup(
                        isExpanded: $showYaw,
                        content: {
                            LineGraphSubView(motionVM: motionVM, showGraph: .attitudeYaw)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Yaw: \((motionVM.coreMotionArray.last?.attitudeYaw ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Yaw") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Yaw Graph")

                    DisclosureGroup(
                        isExpanded: $showHeading,
                        content: {
                            LineGraphSubView(motionVM: motionVM, showGraph: .attitudeHeading)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Heading: \(motionVM.coreMotionArray.last?.attitudeHeading ?? 0.0, specifier: "%.5f")°", comment: "AttitudeView - Heading") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Heading Graph")
                }

                Section(header: Text("Log", comment: "AccelerationView - Section Header"), footer: shareButton) {
                    AttitudeList(motionVM: motionVM)
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
        .sheet(item: $fileToShare, onDismiss: {
            onAppear()
        }) { file in
            ShareSheet(activityItems: [file])
        }
    }

    func shareCSV() {
        motionVM.stopMotionUpdates()
        var csvText = NSLocalizedString("ID;Time;Roll;Pitch;Yaw;Heading", comment: "Export CSV Headline - attitude") + "\n" // swiftlint:disable:this line_length

        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.attitudeRoll.localizedDecimal());\($0.attitudePitch.localizedDecimal());\($0.attitudeYaw.localizedDecimal());\($0.attitudeHeading.localizedDecimal())\n" // swiftlint:disable:this line_length
        }
        fileToShare = exportAPI.getFile(exportText: csvText, filename: "attitude")
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

struct AttitudeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AttitudeView()
        }
    }
}
