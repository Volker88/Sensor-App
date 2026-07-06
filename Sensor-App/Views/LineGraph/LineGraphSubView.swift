//
//  LineGraphSubView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import Charts
import Sensor_App_Framework
import SwiftUI

struct LineGraphSubView: View {

    @Environment(LocationManager.self) private var locationManager
    @Environment(MotionManager.self) private var motionManager
    @Environment(SettingsManager.self) private var settingsManager

    var graph: Graph
    var showGraph: GraphDetail
    var showXAxis: Bool = false

    init(
        graph: Graph,
        showGraph: GraphDetail,
        showXAxis: Bool = false
    ) {
        self.graph = graph
        self.showGraph = showGraph
        self.showXAxis = showXAxis
    }

    var motion: some View {
        let data = motionManager.motionChart
        let xRange: ClosedRange<Int>
        if let first = data.first?.counter, let last = data.last?.counter {
            xRange = first...(last + 1)
        } else {
            xRange = 0...settingsManager.userSettings.graphMaxPointsInt()
        }

        return Chart {
            ForEach(data, id: \.self) { item in
                LineMark(
                    x: .value("Index", item.counter),
                    y: .value("Value", item.graphValue(for: showGraph))
                )
                .interpolationMethod(.linear)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXScale(domain: xRange)
        .chartYScale(domain: yRange(for: data.map { $0.graphValue(for: showGraph) }))
    }

    var altitude: some View {
        let data = motionManager.altitudeChart
        let xRange: ClosedRange<Int>
        if let first = data.first?.counter, let last = data.last?.counter {
            xRange = first...(last + 1)
        } else {
            xRange = 0...settingsManager.userSettings.graphMaxPointsInt()
        }

        return Chart {
            ForEach(data, id: \.self) { item in
                LineMark(
                    x: .value("Index", item.counter),
                    y: .value("Value", item.graphValue(for: showGraph))
                )
                .interpolationMethod(.linear)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXScale(domain: xRange)
        .chartYScale(domain: yRange(for: data.map { $0.graphValue(for: showGraph) }))
    }

    var location: some View {
        let data = locationManager.locationChart
        let xRange: ClosedRange<Int>
        if let first = data.first?.counter, let last = data.last?.counter {
            xRange = first...(last + 1)
        } else {
            xRange = 0...settingsManager.userSettings.graphMaxPointsInt()
        }

        return Chart {
            ForEach(data, id: \.self) { item in
                LineMark(
                    x: .value("Index", item.counter),
                    y: .value("Value", item.graphValue(for: showGraph))
                )
                .interpolationMethod(.linear)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXScale(domain: xRange)
        .chartYScale(domain: yRange(for: data.map { $0.graphValue(for: showGraph) }))
    }

    /// Calculates a Y-axis domain that hugs the data's min and max values, so a
    /// narrow band of values (e.g. 50...51) fills the graph instead of being
    /// compressed against a fixed zero baseline. A small padding keeps the
    /// extreme points off the chart edges, and a flat data set falls back to a
    /// symmetric range around its single value.
    private func yRange(for values: [Double]) -> ClosedRange<Double> {
        guard let minValue = values.min(), let maxValue = values.max() else {
            return 0...1
        }

        guard minValue != maxValue else {
            let padding = abs(minValue) * 0.1
            let fallback = padding == 0 ? 1 : padding
            return (minValue - fallback)...(maxValue + fallback)
        }

        let padding = (maxValue - minValue) * 0.1
        return (minValue - padding)...(maxValue + padding)
    }

    var body: some View {
        VStack {
            Group {
                if graph == .location {
                    location
                } else if graph == .altitude {
                    altitude
                } else {
                    motion
                }
            }
            .chartXAxis(showXAxis ? .automatic : .hidden)
            .accessibilityHidden(true)
            .frame(
                minWidth: 150,
                idealWidth: 200,
                maxWidth: .infinity,
                minHeight: 0,
                idealHeight: 100,
                maxHeight: .infinity,
                alignment: .leading
            )
        }
    }
}

// MARK: - Preview
#Preview("LineGraphSubView - English", traits: .navEmbedded) {
    LineGraphSubView(graph: .location, showGraph: .speed)
}

#Preview("LineGraphSubView - German", traits: .navEmbedded) {
    LineGraphSubView(graph: .location, showGraph: .speed)
        .previewLocalization(.german)
}
