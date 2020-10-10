//
//  GravityView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct GravityView: View {
    
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
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Gravity") + "\n"
        
        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.gravityXAxis.localizedDecimal());\($0.gravityYAxis.localizedDecimal());\($0.gravityZAxis.localizedDecimal())\n"
        }
        fileToShare = exportAPI.getFile(exportText: csvText, filename: "gravity")
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
            Label(NSLocalizedString("Export", comment: "GravityView - Export List"), systemImage: "square.and.arrow.up")
        }
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        // MARK: - Return View
            GeometryReader { g in
                    List {
                        Section(header: Text("Gravity", comment: "GravityView - Section Header")) {
                            DisclosureGroup(
                                isExpanded: $showXAxis,
                                content: {
                                    LineGraphSubView(motionVM: motionVM, showGraph: .gravityXAxis)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("X-Axis: \(motionVM.coreMotionArray.last?.gravityXAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - X-Axis")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle X-Axis Graph")
                            
                            DisclosureGroup(
                                isExpanded: $showYAxis,
                                content: {
                                    LineGraphSubView(motionVM: motionVM, showGraph: .gravityYAxis)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Y-Axis: \(motionVM.coreMotionArray.last?.gravityYAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - Y-Axis")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Y-Axis Graph")
                            
                            DisclosureGroup(
                                isExpanded: $showZAxis,
                                content: {
                                    LineGraphSubView(motionVM: motionVM, showGraph: .gravityZAxis)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Z-Axis: \(motionVM.coreMotionArray.last?.gravityZAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - Z-Axis")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Z-Axis Graph")
                            
                        }
                        
                        Section(header: Text("Log", comment: "AccelerationView - Section Header"), footer: shareButton) {
                            GravityList(motionVM: motionVM)
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
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .sheet(item: $fileToShare) { file in
            ShareSheet(activityItems: [file])
        }
    }
}


// MARK: - Preview
struct GravityView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                GravityView()
                    .colorScheme(scheme)
            }
        }
    }
}
