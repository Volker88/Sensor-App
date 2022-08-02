//
//  LocationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct LocationView: View {
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()
    let exportAPI = ExportAPI()

    @ObservedObject var locationVM: CoreLocationViewModel
    @State private var showShareSheet = false
    @State private var fileToShare: URL?
    @State private var showLatitude = false
    @State private var showLongitude = false
    @State private var showAltitude = false
    @State private var showDirection = false
    @State private var showSpeed = false

    var shareButton: some View {
        Button(action: {
            shareCSV()
        }) {
            Label(NSLocalizedString("Export", comment: "LocationView - Export List"), systemImage: "square.and.arrow.up") // swiftlint:disable:this line_length
        }
    }

    var body: some View {
        GeometryReader { geo in
            List {
                Section(header: Text("Location", comment: "LocationView - Section Header"), footer: shareButton) {
                    DisclosureGroup(
                        isExpanded: $showLatitude,
                        content: {
                            LineGraphSubView(locationVM: locationVM, graph: .location, showGraph: .latitude)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Latitude: \(locationVM.coreLocationArray.last?.latitude ?? 0.0, specifier: "%.6f")° ± \(locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Latitude") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Latitude Graph")

                    DisclosureGroup(
                        isExpanded: $showLongitude,
                        content: {
                            LineGraphSubView(locationVM: locationVM, graph: .location, showGraph: .longitude)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Longitude: \(locationVM.coreLocationArray.last?.longitude ?? 0.0, specifier: "%.6f")° ± \(locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Longitude") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Longitude Graph")

                    DisclosureGroup(
                        isExpanded: $showAltitude,
                        content: {
                            LineGraphSubView(locationVM: locationVM, graph: .location, showGraph: .altitude)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Altitude: \(locationVM.coreLocationArray.last?.altitude ?? 0.0, specifier: "%.2f") ± \(locationVM.coreLocationArray.last?.verticalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Altitude") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Altitude Graph")

                    DisclosureGroup(
                        isExpanded: $showDirection,
                        content: {
                            LineGraphSubView(locationVM: locationVM, graph: .location, showGraph: .course)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text("Direction: \(locationVM.coreLocationArray.last?.course ?? 0.0, specifier: "%.2f")°", comment: "LocationView - Direction") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Direction Graph")

                    DisclosureGroup(
                        isExpanded: $showSpeed,
                        content: {
                            LineGraphSubView(locationVM: locationVM, graph: .location, showGraph: .speed)
                                .frame(height: 100, alignment: .leading)
                        },
                        label: {
                            Text(verbatim: "\(NSLocalizedString("Speed:", comment: "LocationView - Speed")) \(calculationAPI.calculateSpeed(ms: locationVM.coreLocationArray.last?.speed ?? 0.0, to: "\(settings.fetchUserSettings().GPSSpeedSetting)")) \(settings.fetchUserSettings().GPSSpeedSetting)") // swiftlint:disable:this line_length
                        })
                    .disclosureGroupModifier(accessibility: "Toggle Speed Graph")

                    NavigationLink(value: Route.location) {
                        Text("Map", comment: "LocationView - Map")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .frame(
                minWidth: 0,
                idealWidth: geo.size.width,
                maxWidth: .infinity,
                minHeight: 0,
                idealHeight: geo.size.height,
                maxHeight: .infinity,
                alignment: .leading
            )
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            .sheet(item: $fileToShare, onDismiss: {
                onAppear()
            }) { file in
                ShareSheet(activityItems: [file])
            }
        }
    }

    func shareCSV() {
        var csvText = NSLocalizedString("ID;Time;Longitude;Latitude;Altitude;Speed;Course", comment: "Export CSV Headline - Location") + "\n" // swiftlint:disable:this line_length

        _ = locationVM.coreLocationArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.longitude.localizedDecimal());\($0.latitude.localizedDecimal());\($0.altitude.localizedDecimal());\($0.speed.localizedDecimal());\($0.course.localizedDecimal())\n" // swiftlint:disable:this line_length
        }
        fileToShare = exportAPI.getFile(exportText: csvText, filename: "location")
    }

    func onAppear() {
        locationVM.startLocationUpdates()
    }

    func onDisappear() {
        locationVM.stopLocationUpdates()
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LocationView(locationVM: CoreLocationViewModel())
        }
    }
}
