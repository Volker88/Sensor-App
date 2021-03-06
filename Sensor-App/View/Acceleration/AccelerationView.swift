//
//  AccelerationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import SwiftUI

// MARK: - Struct
struct AccelerationView: View {

    // MARK: - Initialize Classes
    let settings = SettingsAPI()
    let exportAPI = ExportAPI()

    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var showShareSheet = false
    @State private var fileToShare: URL?

    // Show Graph
    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false

    // MARK: - Define Constants / Variables

    // MARK: - Initializer

    // MARK: - Methods
    func shareCSV() {
        motionVM.stopMotionUpdates()
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Acceleration") + "\n" // swiftlint:disable:this line_length

        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.accelerationXAxis.localizedDecimal());\($0.accelerationYAxis.localizedDecimal());\($0.accelerationZAxis.localizedDecimal())\n" // swiftlint:disable:this line_length
        }
        fileToShare = exportAPI.getFile(exportText: csvText, filename: "acceleration")
    }

    // MARK: - onAppear / onDisappear
    func onAppear() {
        // Start updating motion
        motionVM.motionUpdateStart()
        motionVM.sensorUpdateInterval = settings.fetchUserSettings().frequencySetting
    }

    func onDisappear() {
        motionVM.stopMotionUpdates()
        motionVM.coreMotionArray.removeAll()
    }

    // MARK: - Content
    var shareButton: some View {
        Button(action: {
            shareCSV()
        }) {
            Label(NSLocalizedString("Export", comment: "AccelerationView - Export List"), systemImage: "square.and.arrow.up") // swiftlint:disable:this line_length
        }
    }

    // MARK: - Body - View
    var body: some View {

        // MARK: - Return View
        GeometryReader { geo in
            List {
                Section(header: Text("Acceleration", comment: "AccelerationView - Section Header")) {
                    DisclosureGroup(
                        isExpanded: $showXAxis,
                        content: {
                            LineGraphSubView(motionVM: motionVM, showGraph: .accelerationXAxis)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("X-Axis: \(motionVM.coreMotionArray.last?.accelerationXAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - X-Axis") // swiftlint:disable:this line_length
                        })
                        .disclosureGroupModifier(accessibility: "Toggle X-Axis Graph")

                    DisclosureGroup(
                        isExpanded: $showYAxis,
                        content: {
                            LineGraphSubView(motionVM: motionVM, showGraph: .accelerationXAxis)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Y-Axis: \(motionVM.coreMotionArray.last?.accelerationYAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - Y-Axis") // swiftlint:disable:this line_length
                        })
                        .disclosureGroupModifier(accessibility: "Toggle Y-Axis Graph")

                    DisclosureGroup(
                        isExpanded: $showZAxis,
                        content: {
                            LineGraphSubView(motionVM: motionVM, showGraph: .accelerationZAxis)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Z-Axis: \(motionVM.coreMotionArray.last?.accelerationZAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - Z-Axis") // swiftlint:disable:this line_length
                        })
                        .disclosureGroupModifier(accessibility: "Toggle Z-Axis Graph")
                }

                Section(header: Text("Log", comment: "AccelerationView - Section Header"), footer: shareButton) {
                    AccelerationList(motionVM: motionVM)
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
}

// MARK: - Preview
struct AccelerationView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                AccelerationView()
                    .colorScheme(scheme)
            }
        }
    }
}
