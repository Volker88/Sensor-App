//
//  AltitudeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AltitudeList: View {

    @Environment(MotionManager.self) private var motionManager

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List(motionManager.altitudeArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "AltitudeList - ID")
                Spacer()
                Text("P:\(motionManager.altitude?.calculatedPressure ?? 0.0, specifier: "%.5f")", comment: "AltitudeList - P")
                Spacer()
                Text("A:\(motionManager.altitude?.calculatedAltitude ?? 0.0, specifier: "%.5f")", comment: "AltitudeList - A")
            }
            .font(.footnote)
        }
        .listStyle(.plain)
        .navigationTitle(NSLocalizedString("Altitude", comment: "NavigationBar Title - Altitude"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareSheet(url: shareCSV())
            }
            CustomToolbar()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText = NSLocalizedString("ID;Time;Pressure;Altitude change", comment: "Export CSV Headline - altitude") + "\n" // swiftlint:disable:this line_length

        _ = motionManager.altitudeArray.map {
            csvText += "\($0.counter);\($0.timestamp);\((motionManager.altitude?.calculatedPressure ?? 0.0).localizedDecimal());\((motionManager.altitude?.calculatedAltitude ?? 0.0).localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "altitude")
    }
}

// MARK: - Preview
#Preview {
    AltitudeList()
        .previewNavigationStackWrapper()
}
