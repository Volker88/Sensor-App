//
//  AttitudeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AttitudeList: View {
    @EnvironmentObject var motionVM: CoreMotionViewModel
    let exportAPI = ExportAPI()

    var body: some View {
        List(motionVM.coreMotionArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "AttitudeList - ID")
                Spacer()
                Text("R:\(item.attitudeRoll * 180 / .pi, specifier: "%.3f")", comment: "AttitudeList - R")
                Spacer()
                Text("P:\(item.attitudePitch * 180 / .pi, specifier: "%.3f")", comment: "AttitudeList - P")
                Spacer()
                Text("Y:\(item.attitudeYaw * 180 / .pi, specifier: "%.3f")", comment: "AttitudeList - Yield")
                Spacer()
                Text("H:\(item.attitudeHeading, specifier: "%.3f")", comment: "AttitudeList - H")
            }
            .font(.footnote)
        }
        .listStyle(.plain)
        .navigationTitle(NSLocalizedString("Attitude", comment: "NavigationBar Title - Attitude"))
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
        var csvText = NSLocalizedString("ID;Time;Roll;Pitch;Yaw;Heading", comment: "Export CSV Headline - attitude") + "\n" // swiftlint:disable:this line_length

        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.attitudeRoll.localizedDecimal());\($0.attitudePitch.localizedDecimal());\($0.attitudeYaw.localizedDecimal());\($0.attitudeHeading.localizedDecimal())\n" // swiftlint:disable:this line_length
        }
        return exportAPI.getFile(exportText: csvText, filename: "attitude")
    }
}

struct AttitudeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AttitudeList()
        }
    }
}
