//
//  LocationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct LocationView: View {

    @Environment(LocationManager.self) private var locationManager

    @State private var showLatitude = false
    @State private var showLongitude = false
    @State private var showAltitude = false
    @State private var showDirection = false
    @State private var showSpeed = false
    @State private var selectedChart: ChartSelection?

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List {
            Section(
                header: Text("Location"),
                footer: ShareSheet(url: shareCSV())
                    .accessibilityHint("Export Location Data to CSV")
                    .accessibilityIdentifier(UIIdentifiers.LocationView.exportButton)
            ) {
                DisclosureGroup(
                    isExpanded: $showLatitude,
                    content: {
                        ExpandableChartView(
                            graph: .location, showGraph: .latitude, title: "Latitude", selectedChart: $selectedChart)
                    },
                    label: {
                        Text(
                            "Latitude: \(locationManager.location?.latitude ?? 0.0, specifier: "%.6f")° ± \(locationManager.location?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m"
                        )
                        .accessibilityHint("Tap to collapse graph", isEnabled: showLatitude)
                        .accessibilityHint("Tap to expand  graph", isEnabled: !showLatitude)
                        .accessibilityInputLabels(["Latitude"])
                        .accessibilityIdentifier(UIIdentifiers.LocationView.latitudeRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showLongitude,
                    content: {
                        ExpandableChartView(
                            graph: .location, showGraph: .longitude, title: "Longitude", selectedChart: $selectedChart)
                    },
                    label: {
                        Text(
                            "Longitude: \(locationManager.location?.longitude ?? 0.0, specifier: "%.6f")° ± \(locationManager.location?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m"
                        )
                        .accessibilityHint("Tap to collapse graph", isEnabled: showLongitude)
                        .accessibilityHint("Tap to expand  graph", isEnabled: !showLongitude)
                        .accessibilityInputLabels(["Longitude"])
                        .accessibilityIdentifier(UIIdentifiers.LocationView.longitudeRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showAltitude,
                    content: {
                        ExpandableChartView(
                            graph: .location, showGraph: .altitude, title: "Altitude", selectedChart: $selectedChart)
                    },
                    label: {
                        Text(
                            "Altitude: \(locationManager.location?.altitude ?? 0.0, specifier: "%.2f") ± \(locationManager.location?.verticalAccuracy ?? 0.0, specifier: "%.2f")m"
                        )
                        .accessibilityHint("Tap to collapse graph", isEnabled: showDirection)
                        .accessibilityHint("Tap to expand  graph", isEnabled: !showDirection)
                        .accessibilityInputLabels(["Altitude"])
                        .accessibilityIdentifier(UIIdentifiers.LocationView.altitudeRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                DisclosureGroup(
                    isExpanded: $showDirection,
                    content: {
                        ExpandableChartView(
                            graph: .location, showGraph: .course, title: "Direction", selectedChart: $selectedChart)
                    },
                    label: {
                        Text("Direction: \(locationManager.location?.course ?? 0.0, specifier: "%.2f")°")
                            .accessibilityHint("Tap to collapse graph", isEnabled: showLatitude)
                            .accessibilityHint("Tap to expand  graph", isEnabled: !showLatitude)
                            .accessibilityInputLabels(["Direction"])
                            .accessibilityIdentifier(UIIdentifiers.LocationView.courseRow)
                    }
                )

                DisclosureGroup(
                    isExpanded: $showSpeed,
                    content: {
                        ExpandableChartView(
                            graph: .location, showGraph: .speed, title: "Speed", selectedChart: $selectedChart)
                    },
                    label: {
                        Text(
                            "Speed: \(locationManager.location?.calculatedSpeed ?? 0.0, specifier: "%.1f") \(locationManager.location?.speedUnit ?? "")"
                        )
                        .accessibilityHint("Tap to collapse graph", isEnabled: showSpeed)
                        .accessibilityHint("Tap to expand  graph", isEnabled: !showSpeed)
                        .accessibilityInputLabels(["Speed"])
                        .accessibilityIdentifier(UIIdentifiers.LocationView.speedRow)
                    }
                )
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityRemoveTraits(.isHeader)

                NavigationLink(value: PositionStack.locationMap) {
                    Text("Map")
                        .accessibilityIdentifier(UIIdentifiers.LocationView.mapButton)
                }

            }

            authorizationStatus()

            SensorStatisticsSection(axes: [
                AxisEntry(label: "Lat", stats: locationManager.statistics(for: .latitude)),
                AxisEntry(label: "Long", stats: locationManager.statistics(for: .longitude)),
                AxisEntry(label: "Alt", stats: locationManager.statistics(for: .altitude)),
                AxisEntry(label: "Speed", stats: locationManager.statistics(for: .speed)),
                AxisEntry(label: "Dir", stats: locationManager.statistics(for: .course))
            ])
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .fullScreenCover(item: $selectedChart) { selection in
            FullScreenChartView(selection: selection)
        }
    }

    // MARK: - Methods
    func authorizationStatus() -> some View {
        Group {
            if locationManager.authorizationStatus != .authorizedWhenInUse {
                HStack {
                    Spacer()

                    VStack {
                        Text("Access to Location Service is required")
                            .foregroundColor(.red)

                        Button {
                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettings)
                            }
                        } label: {
                            Text("Open Settings")
                        }
                    }

                    Spacer()
                }
            }
        }
    }

    func shareCSV() -> URL {
        var csvText = String(localized: "ID;Time;Longitude;Latitude;Altitude;Speed;Course") + "\n"

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
