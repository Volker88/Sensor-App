//
//  MagnetometerList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct MagnetometerList: View {

    @Environment(MotionManager.self) private var motionManager

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List(motionManager.motionArray.reversed(), id: \.self) { item in
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
            CustomToolbar()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Magnetometer") + "\n" // swiftlint:disable:this line_length

        _ = motionManager.motionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.magnetometerXAxis.localizedDecimal());\($0.magnetometerYAxis.localizedDecimal());\($0.magnetometerZAxis.localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "magnetometer")
    }
}

// MARK: - Preview
#Preview {
    MagnetometerList()
        .previewNavigationStackWrapper()
}
