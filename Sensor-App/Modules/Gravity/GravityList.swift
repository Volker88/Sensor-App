//
//  GravityList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import Sensor_App_Framework
import SwiftUI

struct GravityList: View {

    @Environment(MotionManager.self) private var motionManager

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        List(motionManager.motionArray.reversed(), id: \.self) { item in
            HStack {
                Text(verbatim: "#\(item.counter)")
                Spacer()
                Text("X:\(item.gravityXAxis, specifier: "%.5f")", comment: "First Letter as shortcut for X-Axis")
                Spacer()
                Text("Y:\(item.gravityYAxis, specifier: "%.5f")", comment: "First Letter as shortcut for Y-Axis")
                Spacer()
                Text("Z:\(item.gravityZAxis, specifier: "%.5f")", comment: "First Letter as shortcut for Z-Axis")
            }
            .font(.footnote)
        }
        .listStyle(.plain)
        .navigationTitle(Text("Gravity", comment: "NavigationBar Title - Gravity sensor list view"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareSheet(url: shareCSV())
                    .accessibilityLabel("Export Gravity Data to CSV")
                    .accessibilityIdentifier(UIIdentifiers.GravityList.exportButton)
            }
        }
        .safeAreaInset(edge: .bottom) {
            CustomControlsView()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Gravity") + "\n"

        _ = motionManager.motionArray.map {
            csvText +=
                "\($0.counter);\($0.timestamp);\($0.gravityXAxis.localizedDecimal());\($0.gravityYAxis.localizedDecimal());\($0.gravityZAxis.localizedDecimal())\n"
        }
        return exportManager.getFile(exportText: csvText, filename: "gravity")
    }
}

// MARK: - Preview
#Preview("GravityList - English", traits: .navEmbedded) {
    GravityList()
}

#Preview("GravityList - German", traits: .navEmbedded) {
    GravityList()
        .previewLocalization(.german)
}
