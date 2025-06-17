//
//  AccelerationList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import Sensor_App_Framework
import SwiftUI

struct AccelerationList: View {

    @Environment(MotionManager.self) private var motionManager

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List(motionManager.motionArray.reversed(), id: \.self) { item in
            HStack {
                Text(verbatim: "#\(item.counter)")
                Spacer()
                Text("X:\(item.accelerationXAxis, specifier: "%.5f")", comment: "First Letter as shortcut for X-Axis")
                Spacer()
                Text("Y:\(item.accelerationYAxis, specifier: "%.5f")", comment: "First Letter as shortcut for Y-Axis")
                Spacer()
                Text("Z:\(item.accelerationZAxis, specifier: "%.5f")", comment: "First Letter as shortcut for Z-Axis")
            }
            .font(.footnote)
        }
        .listStyle(.plain)
        .navigationTitle(Text("Acceleration", comment: "NavigationBar Title - Acceleration sensor list view"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareSheet(url: shareCSV())
                    .accessibilityLabel("Export Acceleration Data to CSV")
                    .accessibilityIdentifier(UIIdentifiers.AccelerationList.exportButton)
            }
        }
        .safeAreaInset(edge: .bottom) {
            CustomControlsView()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText =
            NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Acceleration") + "\n"  // swiftlint:disable:this line_length

        _ = motionManager.motionArray.map {
            csvText +=
                "\($0.counter);\($0.timestamp);\($0.accelerationXAxis.localizedDecimal());\($0.accelerationYAxis.localizedDecimal());\($0.accelerationZAxis.localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "acceleration")
    }
}

// MARK: - Preview
#Preview("AccelerationList - English", traits: .navEmbedded) {
    AccelerationList()
}

#Preview("AccelerationList - German", traits: .navEmbedded) {
    AccelerationList()
        .previewLocalization(.german)
}
