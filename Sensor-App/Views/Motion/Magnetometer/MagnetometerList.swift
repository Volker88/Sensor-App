//
//  MagnetometerList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import Sensor_App_Framework
import SwiftUI

struct MagnetometerList: View {

    @Environment(MotionManager.self) private var motionManager

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List(motionManager.motionArray.reversed(), id: \.self) { item in
            HStack {
                Text(verbatim: "#\(item.counter)")
                Spacer()
                Text("X:\(item.magnetometerXAxis, specifier: "%.5f")")
                Spacer()
                Text("Y:\(item.magnetometerYAxis, specifier: "%.5f")")
                Spacer()
                Text("Z:\(item.magnetometerZAxis, specifier: "%.5f")")
            }
            .font(.footnote)
        }
        .navigationTitle("Magnetometer")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareSheet(url: shareCSV())
                    .accessibilityLabel("Export Magnetometer Data to CSV")
                    .accessibilityIdentifier(UIIdentifiers.MagnetometerList.exportButton)
            }
        }
        .safeAreaInset(edge: .bottom) {
            CustomControlsView()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText = String(localized: "ID;Time;X-Axis;Y-Axis;Z-Axis") + "\n"

        _ = motionManager.motionArray.map {
            csvText +=
                "\($0.counter);\($0.timestamp);\($0.magnetometerXAxis.localizedDecimal());\($0.magnetometerYAxis.localizedDecimal());\($0.magnetometerZAxis.localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "magnetometer")
    }
}

// MARK: - Preview
#Preview("MagnetometerList - English", traits: .navEmbedded) {
    MagnetometerList()
}

#Preview("MagnetometerList - German", traits: .navEmbedded) {
    MagnetometerList()
        .previewLocalization(.german)
}
