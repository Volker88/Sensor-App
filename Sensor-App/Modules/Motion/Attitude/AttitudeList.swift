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
                Text(verbatim: "#\(item.counter)")
                Spacer()
                Text("R:\(item.attitudeRoll * 180 / .pi, specifier: "%.3f")")
                Spacer()
                Text("P:\(item.attitudePitch * 180 / .pi, specifier: "%.3f")")
                Spacer()
                Text("Y:\(item.attitudeYaw * 180 / .pi, specifier: "%.3f")")
                Spacer()
                Text("H:\(item.attitudeHeading, specifier: "%.3f")")
            }
            .font(.footnote)
        }
        .listStyle(.plain)
        .navigationTitle("Attitude")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareSheet(url: shareCSV())
                    .accessibilityLabel("Export Attitude Data to CSV")
                    .accessibilityIdentifier(UIIdentifiers.AttitudeList.exportButton)
            }
        }
        .safeAreaInset(edge: .bottom) {
            CustomControlsView()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText = String(localized: "ID;Time;Roll;Pitch;Yaw;Heading") + "\n"

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
