//
//  AltitudeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AltitudeList: View {

    @Environment(MotionManager.self) private var motionManager
    @Environment(CalculationManager.self) private var calculationManager
    @Environment(SettingsManager.self) private var settingsManager

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List(motionManager.altitudeArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "AltitudeList - ID")
                Spacer()
                Text("P:\(calculationManager.calculatePressure(pressure: item.pressureValue, to: settingsManager.fetchUserSettings().pressureSetting), specifier: "%.5f")", comment: "AltitudeList - P")
                Spacer()
                Text("A:\(calculationManager.calculateHeight(height: item.relativeAltitudeValue, to: settingsManager.fetchUserSettings().altitudeHeightSetting), specifier: "%.5f")", comment: "AltitudeList - A")
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
            csvText += "\($0.counter);\($0.timestamp);\(calculationManager.calculatePressure(pressure: $0.pressureValue, to: settingsManager.fetchUserSettings().pressureSetting).localizedDecimal());\(calculationManager.calculateHeight(height: $0.relativeAltitudeValue, to: settingsManager.fetchUserSettings().altitudeHeightSetting).localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "altitude")
    }
}

// MARK: - Preview
#Preview {
    AltitudeList()
        .previewNavigationStackWrapper()
}
