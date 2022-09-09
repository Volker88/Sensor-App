//
//  MagnetometerView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct MagnetometerView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject var motionVM: CoreMotionViewModel
    @State private var showShareSheet = false
    @State private var fileToShare: URL?
    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false

    var body: some View {
        GeometryReader { geo in
            List {
                Section(header: Text("Acceleration", comment: "AccelerationView - Section Header")) {
                    DisclosureGroup(
                        isExpanded: $showXAxis,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .magnetometerXAxis)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("X-Axis: \(motionVM.coreMotionArray.last?.magnetometerXAxis ?? 0.0, specifier: "%.5f") µT", comment: "MagnetometerView - X-Axis") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle X-Axis Graph")

                    DisclosureGroup(
                        isExpanded: $showYAxis,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .magnetometerYAxis)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Y-Axis: \(motionVM.coreMotionArray.last?.magnetometerYAxis ?? 0.0, specifier: "%.5f") µT", comment: "MagnetometerView - Y-Axis") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Y-Axis Graph")

                    DisclosureGroup(
                        isExpanded: $showZAxis,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .magnetometerZAxis)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Z-Axis: \(motionVM.coreMotionArray.last?.magnetometerZAxis ?? 0.0, specifier: "%.5f") µT", comment: "MagnetometerView - Z-Axis") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Z-Axis Graph")

                    NavigationLink(value: Route.magnetometerList) {
                        Text("Log", comment: "MagnetometerView - Log")
                    }
                }

                Section(header: Text("Refresh Rate", comment: "MagnetometerView - Section Header")) {
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

struct MagnetometerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MagnetometerView()
        }
    }
}
