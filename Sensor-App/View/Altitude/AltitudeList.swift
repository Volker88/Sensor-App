//
//  AltitudeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI
import OSLog

struct AltitudeList: View {
    @EnvironmentObject var motionVM: CoreMotionViewModel
    let exportManager = ExportManager()
    @Environment(CalculationManager.self) var calculationManager
    @Environment(SettingsManager.self) var settingsManager

    var body: some View {
        List(motionVM.altitudeArray.reversed(), id: \.self) { item in
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
            CustomToolbar(toolBarFunctionClosure: toolBarButtonTapped(button:))
        }
    }

    func toolBarButtonTapped(button: ToolBarButtonType) {
        switch button {
            case .play:
                motionVM.altitudeUpdateStart()
            case .pause:
                motionVM.stopMotionUpdates()
            case .delete:
                motionVM.coreMotionArray.removeAll()
                motionVM.altitudeArray.removeAll()
                Logger.coreLocation.debug("Deleted Motion Data")
        }
    }

    func shareCSV() -> URL {
        var csvText = NSLocalizedString("ID;Time;Pressure;Altitude change", comment: "Export CSV Headline - altitude") + "\n" // swiftlint:disable:this line_length

        _ = motionVM.altitudeArray.map {
            csvText += "\($0.counter);\($0.timestamp);\(calculationManager.calculatePressure(pressure: $0.pressureValue, to: settingsManager.fetchUserSettings().pressureSetting).localizedDecimal());\(calculationManager.calculateHeight(height: $0.relativeAltitudeValue, to: settingsManager.fetchUserSettings().altitudeHeightSetting).localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "altitude")
    }
}

struct AltitudeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AltitudeList()
        }
    }
}
