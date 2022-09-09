//
//  GravityList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct GravityList: View {
    @EnvironmentObject var motionVM: CoreMotionViewModel
    let exportAPI = ExportAPI()

    var body: some View {
        List(motionVM.coreMotionArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "GravityList - ID")
                Spacer()
                Text("X:\(item.gravityXAxis, specifier: "%.5f")", comment: "GravityList - X")
                Spacer()
                Text("Y:\(item.gravityYAxis, specifier: "%.5f")", comment: "GravityList - Y")
                Spacer()
                Text("Z:\(item.gravityZAxis, specifier: "%.5f")", comment: "GravityList - Z")
            }
            .font(.footnote)
        }
        .listStyle(.plain)
        .navigationTitle(NSLocalizedString("Gravity", comment: "NavigationBar Title - GravityList"))
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
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Gravity") + "\n"

        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.gravityXAxis.localizedDecimal());\($0.gravityYAxis.localizedDecimal());\($0.gravityZAxis.localizedDecimal())\n" // swiftlint:disable:this line_length
        }
        return exportAPI.getFile(exportText: csvText, filename: "gravity")
    }
}

struct GravityList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GravityList()
        }
    }
}
