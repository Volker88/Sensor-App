//
//  SensorStatisticsSection.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 09.07.26.
//  Copyright © 2026 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct AxisEntry: Identifiable {
    /// Localized row label. Using `LocalizedStringResource` (not `String`) so `Text` looks it up in the String Catalog.
    let label: LocalizedStringResource
    let stats: AxisStatistics?

    var id: String { label.key }
}

struct SensorStatisticsSection: View {

    let axes: [AxisEntry]

    var body: some View {
        Section("Statistics") {
            if axes.allSatisfy({ $0.stats == nil }) {
                Text("No data recorded yet")
                    .foregroundStyle(.secondary)
            } else {
                HStack {
                    Spacer(minLength: 0)

                    Grid(alignment: .trailing, horizontalSpacing: 16, verticalSpacing: 6) {
                        GridRow {
                            Text(verbatim: "")
                                .gridCellAnchor(.leading)
                            Text("Min")
                                .foregroundStyle(.secondary)
                            Text("Max")
                                .foregroundStyle(.secondary)
                            Text("Avg")
                                .foregroundStyle(.secondary)
                        }
                        .font(.caption)

                        ForEach(axes) { entry in
                            if let stats = entry.stats {
                                GridRow {
                                    Text(entry.label)
                                        .gridCellAnchor(.leading)
                                    Text(stats.min, format: .number.precision(.fractionLength(5)))
                                        .monospacedDigit()
                                    Text(stats.max, format: .number.precision(.fractionLength(5)))
                                        .monospacedDigit()
                                    Text(stats.average, format: .number.precision(.fractionLength(5)))
                                        .monospacedDigit()
                                }
                            }
                        }
                    }
                    .font(.footnote)

                    Spacer(minLength: 0)
                }
            }
        }
    }
}
