//
//  GyroscopeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI
import OSLog

struct GyroscopeList: View {
    @EnvironmentObject var motionVM: CoreMotionViewModel
    @Environment(ExportManager.self) var exportManager

    var body: some View {
        List(motionVM.coreMotionArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "GyroscopeList - ID")
                Spacer()
                Text("X:\(item.gyroXAxis, specifier: "%.5f")", comment: "GyroscopeList - X")
                Spacer()
                Text("Y:\(item.gyroYAxis, specifier: "%.5f")", comment: "GyroscopeList - Y")
                Spacer()
                Text("Z:\(item.gyroZAxis, specifier: "%.5f")", comment: "GyroscopeList - Z")
            }
            .font(.footnote)
        }
        .listStyle(.plain)
        .navigationTitle(NSLocalizedString("Gyroscope", comment: "NavigationBar Title - GyroscopeList"))
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
                motionVM.motionUpdateStart()
            case .pause:
                motionVM.stopMotionUpdates()
            case .delete:
                motionVM.coreMotionArray.removeAll()
                motionVM.altitudeArray.removeAll()
                Logger.coreLocation.debug("Deleted Motion Data")
        }
    }

    func shareCSV() -> URL {
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Gyroscope") + "\n" // swiftlint:disable:this line_length

        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.gyroXAxis.localizedDecimal());\($0.gyroYAxis.localizedDecimal());\($0.gyroZAxis.localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "gyroscope")
    }
}

struct GyroscopeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GyroscopeList()
        }
    }
}
