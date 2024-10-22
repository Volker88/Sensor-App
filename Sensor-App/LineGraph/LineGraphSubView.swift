//
//  LineGraphSubView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import SwiftUI
import Charts

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
        Chart {
                ForEach(motionManager.motionChart, id: \.self) { item in
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
    }

    var altitude: some View {
        Chart {
            ForEach(motionManager.altitudeChart, id: \.self) { item in
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
    }

    var location: some View {
        Chart {
            ForEach(locationManager.locationChart, id: \.self) { item in
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
#Preview(traits: .sizeThatFitsLayout) {
    LineGraphSubView(graph: .location, showGraph: .speed)
        .previewNavigationStackWrapper()
}
