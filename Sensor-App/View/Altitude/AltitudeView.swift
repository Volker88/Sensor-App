//
//  AltitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AltitudeView: View {
    
    // MARK: - Initialize Classes
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()
    let exportAPI = ExportAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var showShareSheet = false
    @State private var filesToShare = [Any]()
    
    // Show Graph
    @State private var showPressure = false
    @State private var showRelativeAltitudeChange = false
    
    // Notification Variables
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0
    
    
    // MARK: - Define Constants / Variables
    
    // MARK: - Initializer
    
    // MARK: - Methods
    func shareCSV() {
        motionVM.stopMotionUpdates()
        var csvText = NSLocalizedString("ID;Time;Pressure;Altitude change", comment: "Export CSV Headline - altitude") + "\n"
        
        _ = motionVM.altitudeArray.map {
            csvText += "\($0.counter);\($0.timestamp);\(calculationAPI.calculatePressure(pressure: $0.pressureValue, to: settings.fetchUserSettings().pressureSetting).localizedDecimal());\(calculationAPI.calculateHeight(height: $0.relativeAltitudeValue, to: settings.fetchUserSettings().altitudeHeightSetting).localizedDecimal())\n"
        }
        filesToShare = exportAPI.getFile(exportText: csvText, filename: "altitude")
        showShareSheet.toggle()
    }
    
    
    // MARK: - onAppear / onDisappear
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
                                isExpanded: $showPressure,
                                content: {
                                    LineGraphSubView(motionVM: motionVM, showGraph: .pressureValue)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Pressure: \(calculationAPI.calculatePressure(pressure: motionVM.altitudeArray.last?.pressureValue ?? 0.0, to: settings.fetchUserSettings().pressureSetting), specifier: "%.5f") \(settings.fetchUserSettings().pressureSetting)", comment: "AltitudeView - Pressure")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Pressure Graph")
                            
                            DisclosureGroup(
                                isExpanded: $showRelativeAltitudeChange,
                                content: {
                                    LineGraphSubView(motionVM: motionVM, showGraph: .relativeAltitudeValue)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Altitude change: \(calculationAPI.calculateHeight(height: motionVM.altitudeArray.last?.relativeAltitudeValue ?? 0.0, to: settings.fetchUserSettings().altitudeHeightSetting), specifier: "%.5f") \(settings.fetchUserSettings().altitudeHeightSetting)", comment: "AltitudeView - Altitude")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Altitude Graph")
                        }
                        
                        Section(header: Text("Log", comment: "AccelerationView - Section Header"), footer: shareButton) {
                            AltitudeList(motionVM: motionVM)
                                .frame(height: 200, alignment: .center)
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
struct AltitudeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                AltitudeView()
                    .colorScheme(scheme)
            }
        }
    }
}
