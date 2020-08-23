//
//  AttitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AttitudeView: View {
    
    // MARK: - Initialize Classes
    let settings = SettingsAPI()
    let exportAPI = ExportAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @StateObject var motionVM = CoreMotionViewModel()
    @State private var showShareSheet = false
    @State private var filesToShare = [Any]()
    
    // Show Graph
    @State private var showRoll = false
    @State private var showPitch = false
    @State private var showYaw = false
    @State private var showHeading = false
    
    
    // MARK: - Define Constants / Variables
    
    // MARK: - Initializer
    
    // MARK: - Methods
    func shareCSV() {
        motionVM.stopMotionUpdates()
        var csvText = NSLocalizedString("ID;Time;Roll;Pitch;Yaw;Heading", comment: "Export CSV Headline - attitude") + "\n"
        
        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.attitudeRoll.localizedDecimal());\($0.attitudePitch.localizedDecimal());\($0.attitudeYaw.localizedDecimal());\($0.attitudeHeading.localizedDecimal())\n"
        }
        filesToShare = exportAPI.getFile(exportText: csvText, filename: "attitude")
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
                        Section(header: Text("Attitude", comment: "AttitudeView - Section Header")) {
                            DisclosureGroup(
                                isExpanded: $showRoll,
                                content: {
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .attitudeRoll)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Roll: \((self.motionVM.coreMotionArray.last?.attitudeRoll ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Roll")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Roll Graph")
                            
                            
                            DisclosureGroup(
                                isExpanded: $showPitch,
                                content: {
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .attitudePitch)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Pitch: \((self.motionVM.coreMotionArray.last?.attitudePitch ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Pitch")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Pitch Graph")
                            
                            
                            DisclosureGroup(
                                isExpanded: $showYaw,
                                content: {
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .attitudeYaw)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Yaw: \((self.motionVM.coreMotionArray.last?.attitudeYaw ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Yaw")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Roll Graph")
                            
                            DisclosureGroup(
                                isExpanded: $showHeading,
                                content: {
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .attitudeHeading)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Heading: \(self.motionVM.coreMotionArray.last?.attitudeHeading ?? 0.0, specifier: "%.5f")°", comment: "AttitudeView - Heading")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Heading Graph")
                        }
                        
                        Section(header: Text("List", comment: "AccelerationView - Section Header"), footer: shareButton) {
                            AttitudeList(motionVM: motionVM)
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
struct AttitudeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                AttitudeView()
                    .colorScheme(scheme)
            }
        }
    }
}