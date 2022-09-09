//
//  AccelerationList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AccelerationList: View {
    @EnvironmentObject var motionVM: CoreMotionViewModel
    let exportAPI = ExportAPI()

    var body: some View {
        List(motionVM.coreMotionArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "AccelerationList - ID")
                Spacer()
                Text("X:\(item.accelerationXAxis, specifier: "%.5f")", comment: "AccelerationList - X")
                Spacer()
                Text("Y:\(item.accelerationYAxis, specifier: "%.5f")", comment: "AccelerationList - Y")
                Spacer()
                Text("Z:\(item.accelerationZAxis, specifier: "%.5f")", comment: "AccelerationList - Z")
            }
            .font(.footnote)
        }
        .listStyle(.plain)
        .navigationTitle(NSLocalizedString("Acceleration", comment: "NavigationBar Title - AccelerationList"))
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
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Acceleration") + "\n" // swiftlint:disable:this line_length

        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.accelerationXAxis.localizedDecimal());\($0.accelerationYAxis.localizedDecimal());\($0.accelerationZAxis.localizedDecimal())\n" // swiftlint:disable:this line_length
        }
        return exportAPI.getFile(exportText: csvText, filename: "acceleration")
    }
}

struct AccelerationList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccelerationList()
        }
    }
}
