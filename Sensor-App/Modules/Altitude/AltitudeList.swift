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
        List(motionManager.altitudeArray.reversed(), id: \.self) { item in
            HStack {
                Text("#\(item.counter)", comment: "Incrementing counter for each item.  DO NOT TRANSLATE")
                Spacer()
                Text(
                    "P:\(motionManager.altitude?.calculatedPressure ?? 0.0, specifier: "%.3f")",
                    comment: "First Letter as shortcut for Pressure")
                Spacer()
                Text(
                    "A:\(motionManager.altitude?.calculatedAltitude ?? 0.0, specifier: "%.3f")",
                    comment: "First Letter as shortcut for Altitude")
            }
            .font(.footnote)
        }
        .listStyle(.plain)
        .navigationTitle(Text("Altitude", comment: "NavigationBar Title - Altitude sensor list view"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareSheet(url: shareCSV())
                    .accessibilityLabel("Export Altitude Data to CSV")
                    .accessibilityIdentifier(UIIdentifiers.AltitudeList.exportButton)
            }
            CustomToolbar()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText =
            NSLocalizedString("ID;Time;Pressure;Altitude change", comment: "Export CSV Headline - altitude") + "\n"  // swiftlint:disable:this line_length

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
