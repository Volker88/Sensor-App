//
//  AltitudeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import Sensor_App_Framework
import SwiftUI

struct AltitudeList: View {

    @Environment(MotionManager.self) private var motionManager

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List {
            SensorStatisticsSection(axes: [
                AxisEntry(label: "Pressure", stats: motionManager.statistics(for: .pressureValue)),
                AxisEntry(label: "Altitude", stats: motionManager.statistics(for: .relativeAltitudeValue))
            ])

            ForEach(motionManager.altitudeArray.reversed(), id: \.self) { item in
                HStack {
                    Text(verbatim: "#\(item.counter)")
                    Spacer()
                    Text("P:\(motionManager.altitude?.calculatedPressure ?? 0.0, specifier: "%.3f")")
                    Spacer()
                    Text("A:\(motionManager.altitude?.calculatedAltitude ?? 0.0, specifier: "%.3f")")
                }
                .font(.footnote)
            }
        }
        .listStyle(.plain)
        .navigationTitle(RootTab.altitude.localizedString)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareSheet(url: shareCSV())
                    .accessibilityHint("Export Altitude Data to CSV")
                    .accessibilityIdentifier(UIIdentifiers.AltitudeList.exportButton)
            }
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 175)
        }
        .overlay(alignment: .bottom) {
            CustomControlsView()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText = String(localized: "ID;Time;Pressure;Altitude Change") + "\n"

        _ = motionManager.altitudeArray.map {
            csvText +=
                "\($0.counter);\($0.timestamp);\((motionManager.altitude?.calculatedPressure ?? 0.0).localizedDecimal());\((motionManager.altitude?.calculatedAltitude ?? 0.0).localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "altitude")
    }
}

// MARK: - Preview
#Preview("AltitudeList - English", traits: .navEmbedded) {
    AltitudeList()
}

#Preview("AltitudeList - German", traits: .navEmbedded) {
    AltitudeList()
        .previewLocalization(.german)
}
