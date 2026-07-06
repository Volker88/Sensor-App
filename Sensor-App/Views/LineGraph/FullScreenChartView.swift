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
        }
    }
}

// MARK: - Preview
#Preview("FullScreenChartView - English") {
    FullScreenChartView(
        selection: ChartSelection(graph: .motion, detail: .accelerationXAxis, title: "X-Axis")
    )
}
