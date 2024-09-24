//
//  MagnetometerList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI
import OSLog

struct MagnetometerList: View {
    @Environment(MotionManager.self) var motionManager
    let exportManager = ExportManager()

    var body: some View {
        List(motionManager.motionArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "MagnetometerList - ID")
                Spacer()
                Text("X:\(item.magnetometerXAxis, specifier: "%.5f")", comment: "MagnetometerList - X")
                Spacer()
                Text("Y:\(item.magnetometerYAxis, specifier: "%.5f")", comment: "MagnetometerList - Y")
                Spacer()
                Text("Z:\(item.magnetometerZAxis, specifier: "%.5f")", comment: "MagnetometerList - Z")
            }
            .font(.footnote)
        }
        .navigationTitle(NSLocalizedString("Magnetometer", comment: "NavigationBar Title - MagnetometerList"))
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
                motionManager.startMotionUpdates()
            case .pause:
                motionManager.stopMotionUpdates()
            case .delete:
                motionManager.resetMotionUpdates()
                Logger.coreLocation.debug("Deleted Motion Data")
        }
    }

    func shareCSV() -> URL {
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Magnetometer") + "\n" // swiftlint:disable:this line_length

        _ = motionManager.motionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.magnetometerXAxis.localizedDecimal());\($0.magnetometerYAxis.localizedDecimal());\($0.magnetometerZAxis.localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "magnetometer")
    }
}

struct MagnetometerList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MagnetometerList()
        }
    }
}
