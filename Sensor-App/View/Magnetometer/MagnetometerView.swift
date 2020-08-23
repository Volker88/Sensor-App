//
//  MagnetometerView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct MagnetometerView: View {
    
    // MARK: - Initialize Classes
    let settings = SettingsAPI()
    let exportAPI = ExportAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @StateObject var motionVM = CoreMotionViewModel()
    @State private var showShareSheet = false
    @State private var filesToShare = [Any]()
    
    // Show Graph
    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false
    
    // MARK: - Define Constants / Variables
    
    // MARK: - Initializer
    
    // MARK: - Methods
    func shareCSV() {
        motionVM.stopMotionUpdates()
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Magnetometer") + "\n"
        
        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.magnetometerXAxis.localizedDecimal());\($0.magnetometerYAxis.localizedDecimal());\($0.magnetometerZAxis.localizedDecimal())\n"
        }
        filesToShare = exportAPI.getFile(exportText: csvText, filename: "magnetometer")
        self.showShareSheet.toggle()
    }
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        // Start updating motion
        motionVM.motionUpdateStart()
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
            Label(NSLocalizedString("Export", comment: "AccelerationView - Export List"), systemImage: "square.and.arrow.up")
        }
    }
    
    
    // MARK: - Body - View
    @ViewBuilder
    var body: some View {
        
        // MARK: - Return View
        ZStack {
            GeometryReader { g in
                    ScrollView {
                        List {
                            Section(header: Text("Acceleration", comment: "AccelerationView - Section Header")) {
                                DisclosureGroup(
                                    isExpanded: $showXAxis,
                                    content: {
                                        LineGraphSubView(motionVM: self.motionVM, showGraph: .magnetometerXAxis)
                                            .frame(height: 100, alignment: .leading)
                                    },
                                    label: {
                                        Text("X-Axis: \(self.motionVM.coreMotionArray.last?.magnetometerXAxis ?? 0.0, specifier: "%.5f") µT", comment: "MagnetometerView - X-Axis")
                                    })
                                    .disclosureGroupModifier(accessibility: "Toggle X-Axis Graph")
                                
                                DisclosureGroup(
                                    isExpanded: $showYAxis,
                                    content: {
                                        LineGraphSubView(motionVM: self.motionVM, showGraph: .magnetometerYAxis)
                                            .frame(height: 100, alignment: .leading)
                                    },
                                    label: {
                                        Text("Y-Axis: \(self.motionVM.coreMotionArray.last?.magnetometerYAxis ?? 0.0, specifier: "%.5f") µT", comment: "MagnetometerView - Y-Axis")
                                    })
                                    .disclosureGroupModifier(accessibility: "Toggle Y-Axis Graph")
                                
                                DisclosureGroup(
                                    isExpanded: $showZAxis,
                                    content: {
                                        LineGraphSubView(motionVM: self.motionVM, showGraph: .magnetometerZAxis)
                                            .frame(height: 100, alignment: .leading)
                                    },
                                    label: {
                                        Text("Z-Axis: \(self.motionVM.coreMotionArray.last?.magnetometerZAxis ?? 0.0, specifier: "%.5f") µT", comment: "MagnetometerView - Z-Axis")
                                    })
                                    .disclosureGroupModifier(accessibility: "Toggle Z-Axis Graph")
                        }
                        
                        Section(header: Text("List", comment: "AccelerationView - Section Header"), footer: shareButton) {
                            MagnetometerList(motionVM: motionVM)
                                .frame(height: 200, alignment: .center)
                        }
                        
                        Section(header: Text("Refresh Rate", comment: "AccelerationView - Section Header")) {
                            RefreshRateView(motionVM: motionVM, show: "header")
                            RefreshRateView(motionVM: motionVM, show: "slider")
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .frame(minWidth: 0, idealWidth: g.size.width, maxWidth: .infinity, minHeight: 0, idealHeight: g.size.height, maxHeight: g.size.height, alignment: .leading)
                }
            }
        }
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .sheet(isPresented: $showShareSheet) { ShareSheet(activityItems: filesToShare) }
    }
}


// MARK: - Preview
struct MagnetometerView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                MagnetometerView()
                    .colorScheme(scheme)
            }
        }
    }
}
