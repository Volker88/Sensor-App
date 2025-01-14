//
//  LocationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct LocationView: View {

    @Environment(LocationManager.self) private var locationManager

    @State private var showLatitude = false
    @State private var showLongitude = false
    @State private var showAltitude = false
    @State private var showDirection = false
    @State private var showSpeed = false

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List {
            Section(
                header: Text("Location", comment: "LocationView - Section Header"),
                footer: ShareSheet(url: shareCSV())
                    .accessibility(identifier: "ExportButton")
            ) {
                DisclosureGroup(
                    isExpanded: $showLatitude,
                    content: {
                        LineGraphSubView(graph: .location, showGraph: .latitude)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Latitude: \(locationManager.location?.latitude ?? 0.0, specifier: "%.6f")° ± \(locationManager.location?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m",
                            comment: "GPS Latitude position with accuracy in meter")
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle Latitude Graph")

                DisclosureGroup(
                    isExpanded: $showLongitude,
                    content: {
                        LineGraphSubView(graph: .location, showGraph: .longitude)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Longitude: \(locationManager.location?.longitude ?? 0.0, specifier: "%.6f")° ± \(locationManager.location?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m",
                            comment: "GPS Longitude position with accuracy in meter")
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle Longitude Graph")

                DisclosureGroup(
                    isExpanded: $showAltitude,
                    content: {
                        LineGraphSubView(graph: .location, showGraph: .altitude)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Altitude: \(locationManager.location?.altitude ?? 0.0, specifier: "%.2f") ± \(locationManager.location?.verticalAccuracy ?? 0.0, specifier: "%.2f")m",
                            comment: "GPS Altitude position with accuracy in meter")
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle Altitude Graph")

                DisclosureGroup(
                    isExpanded: $showDirection,
                    content: {
                        LineGraphSubView(graph: .location, showGraph: .course)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Direction: \(locationManager.location?.course ?? 0.0, specifier: "%.2f")°",
                            comment: "GPS moving direction")
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle Direction Graph")

                DisclosureGroup(
                    isExpanded: $showSpeed,
                    content: {
                        LineGraphSubView(graph: .location, showGraph: .speed)
                            .frame(height: 100, alignment: .leading)
                    },
                    label: {
                        Text(
                            "Speed: \(locationManager.location?.calculatedSpeed ?? 0.0, specifier: "%.1f") \(locationManager.location?.speedUnit ?? "")"
                        )
                    }
                )
                .disclosureGroupModifier(accessibility: "Toggle Speed Graph")

                NavigationLink(value: Route.location) {
                    Text("Map", comment: "Map to show current GPS position")
                }
            }

            authorizationStatus()
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    // MARK: - Methods
    func authorizationStatus() -> some View {
        Group {
            if locationManager.authorizationStatus != .authorizedWhenInUse {
                HStack {
                    Spacer()

                    VStack {
                        Text(
                            "Access to Location Service is required", comment: "Access to Location Service is required"
                        )
                        .foregroundColor(.red)

                        Button {
                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettings)
                            }
                        } label: {
                            Text("Open Settings", comment: "Open iOS Settings Menu")
                        }
                    }

                    Spacer()
                }
            }
        }
    }

    func shareCSV() -> URL {
        var csvText =
            NSLocalizedString(
                "ID;Time;Longitude;Latitude;Altitude;Speed;Course", comment: "Export CSV Headline - Location") + "\n"  // swiftlint:disable:this line_length

        _ = locationManager.locationArray.map {
            csvText +=
                "\($0.counter);\($0.timestamp);\($0.longitude.localizedDecimal());\($0.latitude.localizedDecimal());\($0.altitude.localizedDecimal());\($0.speed.localizedDecimal());\($0.course.localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "location")
    }

    func onAppear() {
        locationManager.startLocationUpdates()
    }

    func onDisappear() {
        locationManager.stopLocationUpdates()
        locationManager.resetLocationUpdates()
    }
}

// MARK: - Preview
#Preview("LocationView - English", traits: .navEmbedded) {
    LocationView()
}

#Preview("LocationView - German", traits: .navEmbedded) {
    LocationView()
        .previewLocalization(.german)
}
