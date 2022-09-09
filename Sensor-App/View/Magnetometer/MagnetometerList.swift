//
//  MagnetometerList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct MagnetometerList: View {
    @EnvironmentObject var motionVM: CoreMotionViewModel
    let exportAPI = ExportAPI()

    var body: some View {
        List(motionVM.coreMotionArray.reversed(), id: \.self) { item in
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
                motionVM.motionUpdateStart()
            case .pause:
                motionVM.stopMotionUpdates()
            case .delete:
                motionVM.coreMotionArray.removeAll()
                motionVM.altitudeArray.removeAll()
                Log.shared.add(.coreLocation, .default, "Deleted Motion Data")
        }
    }

    func shareCSV() -> URL {
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Magnetometer") + "\n" // swiftlint:disable:this line_length

        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.magnetometerXAxis.localizedDecimal());\($0.magnetometerYAxis.localizedDecimal());\($0.magnetometerZAxis.localizedDecimal())\n" // swiftlint:disable:this line_length
        }
        return exportAPI.getFile(exportText: csvText, filename: "magnetometer")
    }
}

struct MagnetometerList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MagnetometerList()
        }
    }
}
