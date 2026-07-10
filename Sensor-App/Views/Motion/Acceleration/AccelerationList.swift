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
        List {
            SensorStatisticsSection(axes: [
                AxisEntry(label: "X", stats: motionManager.statistics(for: .accelerationXAxis)),
                AxisEntry(label: "Y", stats: motionManager.statistics(for: .accelerationYAxis)),
                AxisEntry(label: "Z", stats: motionManager.statistics(for: .accelerationZAxis))
            ])

            ForEach(motionManager.motionArray.reversed(), id: \.self) { item in
                HStack {
                    Text(verbatim: "#\(item.counter)")
                    Spacer()
                    Text("X:\(item.accelerationXAxis, specifier: "%.5f")")
                    Spacer()
                    Text("Y:\(item.accelerationYAxis, specifier: "%.5f")")
                    Spacer()
                    Text("Z:\(item.accelerationZAxis, specifier: "%.5f")")
                }
                .font(.footnote)
            }
        }
        .listStyle(.plain)
        .navigationTitle(RootTab.acceleration.localizedString)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareSheet(url: shareCSV())
                    .accessibilityHint("Export Acceleration Data to CSV")
                    .accessibilityIdentifier(UIIdentifiers.AccelerationList.exportButton)
            }
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 175)
        }
        .overlay(alignment: .bottom) {
            CustomControlsView()
        }
    }

    // MARK: - Methods
    func shareCSV() -> URL {
        var csvText = String(localized: "ID;Time;X-Axis;Y-Axis;Z-Axis") + "\n"

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
