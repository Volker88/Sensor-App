//
//  FullScreenChartView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 06.07.26.
//  Copyright © 2026 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct FullScreenChartView: View {

    var selection: ChartSelection
    @Environment(\.dismiss) private var dismiss
    @Environment(MotionManager.self) private var motionManager
    @Environment(LocationManager.self) private var locationManager

    private var resolvedStats: AxisStatistics? {
        switch selection.graph {
            case .motion, .altitude:
                return motionManager.statistics(for: selection.detail)
            case .location:
                return locationManager.statistics(for: selection.detail)
        }
    }

    var body: some View {
        NavigationStack {
            LineGraphSubView(graph: selection.graph, showGraph: selection.detail, showXAxis: true)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(Text(selection.title))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { dismiss() }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    if let stats = resolvedStats {
                        HStack(spacing: 32) {
                            Spacer()
                            statsColumn(label: "Min", value: stats.min)
                            statsColumn(label: "Max", value: stats.max)
                            statsColumn(label: "Avg", value: stats.average)
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .background(.regularMaterial)
                    }
                }
        }
    }

    private func statsColumn(label: LocalizedStringKey, value: Double) -> some View {
        VStack(alignment: .center, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value, format: .number.precision(.fractionLength(5)))
                .font(.caption)
                .monospacedDigit()
        }
    }
}

// MARK: - Preview
#Preview("FullScreenChartView - English") {
    FullScreenChartView(
        selection: ChartSelection(graph: .motion, detail: .accelerationXAxis, title: "X-Axis")
    )
}

#Preview("FullScreenChartView - German") {
    FullScreenChartView(
        selection: ChartSelection(graph: .motion, detail: .accelerationXAxis, title: "X-Axis")
    )
    .previewLocalization(.german)
}
