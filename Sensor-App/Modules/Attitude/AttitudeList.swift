//
//  AttitudeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import Sensor_App_Framework
import SwiftUI

struct AttitudeList: View {

    @Environment(MotionManager.self) private var motionManager

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List(motionManager.motionArray.reversed(), id: \.self) { item in
            HStack {
                Text("#\(item.counter)", comment: "Incrementing counter for each item.  DO NOT TRANSLATE")
                Spacer()
                Text(
                    "R:\(item.attitudeRoll * 180 / .pi, specifier: "%.3f")",
                    comment: "Attitude Sensor. First Letter as shortcut for Roll")
                Spacer()
                Text(
                    "P:\(item.attitudePitch * 180 / .pi, specifier: "%.3f")",
                    comment: "Attitude Sensor. First Letter as shortcut for Pitch")
                Spacer()
                Text(
                    "Y:\(item.attitudeYaw * 180 / .pi, specifier: "%.3f")",
                    comment: "Attitude Sensor. First Letter as shortcut for Yaw")
                Spacer()
                Text(
                    "H:\(item.attitudeHeading, specifier: "%.3f")",
                    comment: "Attitude Sensor. First Letter as shortcut for Heading")
            }
            .font(.footnote)
        }
        .listStyle(.plain)
        .navigationTitle(Text("Attitude", comment: "NavigationBar Title - Attitude sensor list view"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareSheet(url: shareCSV())
                    .accessibility(identifier: "ExportButton")
            }
            CustomToolbar()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText =
            NSLocalizedString("ID;Time;Roll;Pitch;Yaw;Heading", comment: "Export CSV Headline - attitude") + "\n"  // swiftlint:disable:this line_length

        _ = motionManager.motionArray.map {
            csvText +=
                "\($0.counter);\($0.timestamp);\($0.attitudeRoll.localizedDecimal());\($0.attitudePitch.localizedDecimal());\($0.attitudeYaw.localizedDecimal());\($0.attitudeHeading.localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "attitude")
    }
}

// MARK: - Preview
#Preview("AttitudeList - English", traits: .navEmbedded) {
    AttitudeList()
}

#Preview("AttitudeList - German", traits: .navEmbedded) {
    AttitudeList()
        .previewLocalization(.german)
}
