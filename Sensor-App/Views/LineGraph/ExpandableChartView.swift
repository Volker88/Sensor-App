//
//  ExpandableChartView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 06.07.26.
//  Copyright © 2026 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct ExpandableChartView: View {

    let graph: Graph
    let showGraph: GraphDetail
    let title: LocalizedStringResource
    @Binding var selectedChart: ChartSelection?

    var body: some View {
        LineGraphSubView(graph: graph, showGraph: showGraph)
            .frame(height: 100, alignment: .leading)
            .overlay(alignment: .topTrailing) {
                Button {
                    selectedChart = ChartSelection(graph: graph, detail: showGraph, title: title)
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right.circle.fill")
                        .imageScale(.medium)
                        .foregroundStyle(.secondary)
                        .padding(4)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("View \(title) chart full screen"))
            }
    }
}
