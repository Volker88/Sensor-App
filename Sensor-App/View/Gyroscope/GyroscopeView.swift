//
//  GyroscopeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 14.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct GyroscopeView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject var motionVM: CoreMotionViewModel
    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false

    var body: some View {
        GeometryReader { geo in
            List {
                Section(header: Text("Gyroscope", comment: "GyroscopeView - Section Header")) {
                    DisclosureGroup(
                        isExpanded: $showXAxis,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .gyroXAxis)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("X-Axis: \(motionVM.coreMotionArray.last?.gyroXAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyroscopeView - X-Axis") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle X-Axis Graph")

                    DisclosureGroup(
                        isExpanded: $showYAxis,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .gyroYAxis)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Y-Axis: \(motionVM.coreMotionArray.last?.gyroYAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyroscopeView - Y-Axis") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Y-Axis Graph")

                    DisclosureGroup(
                        isExpanded: $showZAxis,
                        content: {
                            LineGraphSubView(motionVM: motionVM, graph: .motion, showGraph: .gyroZAxis)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Z-Axis: \(motionVM.coreMotionArray.last?.gyroZAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyroscopeView - Z-Axis") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Z-Axis Graph")

                    NavigationLink(value: Route.gyroscopeList) {
                        Text("Log", comment: "GyroscopeView - Log")
                    }
                }

                Section(header: Text("Refresh Rate", comment: "GyroscopeView - Section Header")) {
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

struct GyroscopeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GyroscopeView()
        }
    }
}
