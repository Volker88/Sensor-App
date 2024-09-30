//
//  GravityList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct GravityList: View {

    @Environment(MotionManager.self) private var motionManager

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List(motionManager.motionArray.reversed(), id: \.self) { item in
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
                    .accessibility(identifier: "ExportButton")
            }
            CustomToolbar()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Gravity") + "\n"

        _ = motionManager.motionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.gravityXAxis.localizedDecimal());\($0.gravityYAxis.localizedDecimal());\($0.gravityZAxis.localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "gravity")
    }
}

// MARK: - Preview
#Preview {
    GravityList()
        .previewNavigationStackWrapper()
}
