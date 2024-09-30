//
//  AccelerationList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AccelerationList: View {

    @Environment(MotionManager.self) private var motionManager

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List(motionManager.motionArray.reversed(), id: \.self) { item in
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
                    .accessibility(identifier: "ExportButton")
            }
            CustomToolbar()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Acceleration") + "\n" // swiftlint:disable:this line_length

        _ = motionManager.motionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.accelerationXAxis.localizedDecimal());\($0.accelerationYAxis.localizedDecimal());\($0.accelerationZAxis.localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "acceleration")
    }
}

// MARK: - Preview
#Preview {
    AccelerationList()
        .previewNavigationStackWrapper()
}
