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

    init(
        graph: Graph,
        showGraph: GraphDetail
    ) {
        self.graph = graph
        self.showGraph = showGraph
    }

    var motion: some View {
        let data = motionManager.motionChart
        let xRange: ClosedRange<Int>
        if let first = data.first?.counter, let last = data.last?.counter {
            xRange = first...last
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
    }

    var altitude: some View {
        let data = motionManager.altitudeChart
        let xRange: ClosedRange<Int>
        if let first = data.first?.counter, let last = data.last?.counter {
            xRange = first...last
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
    }

    var location: some View {
        let data = locationManager.locationChart
        let xRange: ClosedRange<Int>
        if let first = data.first?.counter, let last = data.last?.counter {
            xRange = first...last
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
            .chartXAxis(.hidden)
            .frame(
                minWidth: 150,
                idealWidth: 200,
                maxWidth: .infinity,
                minHeight: 0,
                idealHeight: 100,
                maxHeight: 100,
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
