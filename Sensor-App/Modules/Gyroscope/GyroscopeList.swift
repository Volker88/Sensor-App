//
//  GyroscopeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import Sensor_App_Framework
import SwiftUI

struct GyroscopeList: View {

    @Environment(MotionManager.self) private var motionManager

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List(motionManager.motionArray.reversed(), id: \.self) { item in
            HStack {
                Text(verbatim: "#\(item.counter)")
                Spacer()
                Text("X:\(item.gyroXAxis, specifier: "%.5f")", comment: "First Letter as shortcut for X-Axis")
                Spacer()
                Text("Y:\(item.gyroYAxis, specifier: "%.5f")", comment: "First Letter as shortcut for Y-Axis")
                Spacer()
                Text("Z:\(item.gyroZAxis, specifier: "%.5f")", comment: "First Letter as shortcut for Z-Axis")
            }
            .font(.footnote)
        }
        .listStyle(.plain)
        .navigationTitle(Text("Gyroscope", comment: "NavigationBar Title - Gyroscope sensor list view"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareSheet(url: shareCSV())
                    .accessibilityLabel("Export Gyroscope Data to CSV")
                    .accessibilityIdentifier(UIIdentifiers.GyroscopeList.exportButton)
            }
        }
        .safeAreaInset(edge: .bottom) {
            CustomControlsView()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText =
            NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Gyroscope") + "\n"  // swiftlint:disable:this line_length

        _ = motionManager.motionArray.map {
            csvText +=
                "\($0.counter);\($0.timestamp);\($0.gyroXAxis.localizedDecimal());\($0.gyroYAxis.localizedDecimal());\($0.gyroZAxis.localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "gyroscope")
    }
}

// MARK: - Preview
#Preview("GyroscopeList - English", traits: .navEmbedded) {
    GyroscopeList()
}

#Preview("GyroscopeList - German", traits: .navEmbedded) {
    GyroscopeList()
        .previewLocalization(.german)
}
