//
//  AttitudeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AttitudeList: View {

    @Environment(MotionManager.self) private var motionManager

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List(motionManager.motionArray.reversed(), id: \.self) { item in
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
            CustomToolbar()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText = NSLocalizedString("ID;Time;Roll;Pitch;Yaw;Heading", comment: "Export CSV Headline - attitude") + "\n" // swiftlint:disable:this line_length

        _ = motionManager.motionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.attitudeRoll.localizedDecimal());\($0.attitudePitch.localizedDecimal());\($0.attitudeYaw.localizedDecimal());\($0.attitudeHeading.localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "attitude")
    }
}

// MARK: - Preview
#Preview {
    AttitudeList()
        .previewNavigationStackWrapper()
}
