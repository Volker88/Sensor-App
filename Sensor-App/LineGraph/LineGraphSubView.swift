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
    @ObservedObject var motionVM: CoreMotionViewModel
    @ObservedObject var locationVM: CoreLocationViewModel

    let settings = SettingsAPI()
    var graph: Graph
    var showGraph: GraphDetail

    init(
        motionVM: CoreMotionViewModel? = nil,
        locationVM: CoreLocationViewModel? = nil,
        graph: Graph,
        showGraph: GraphDetail
    ) {
        self.motionVM = motionVM ?? CoreMotionViewModel()
        self.locationVM = locationVM ?? CoreLocationViewModel()
        self.graph = graph
        self.showGraph = showGraph
    }

    var motion: some View {
        Chart(
            motionVM.coreMotionArray.suffix(settings.fetchUserSettings().graphMaxPointsInt()),
            id: \.self
        ) { item in
            LineMark(
                x: .value("", item.timestamp),
                y: .value("", item.graphValue(for: showGraph))
            )
        }
    }

    var location: some View {
        Chart(
            locationVM.coreLocationArray.suffix(settings.fetchUserSettings().graphMaxPointsInt()),
            id: \.self
        ) { item in
            LineMark(
                x: .value("", item.timestamp),
                y: .value("", item.graphValue(for: showGraph))
            )
        }
    }

    var body: some View {
        GeometryReader { _ in
            VStack {
                Group {
                    if graph == .location {
                        location
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
}

struct LineGraphImplementation_Previews: PreviewProvider {
    static var previews: some View {
        LineGraphSubView(graph: .location, showGraph: .speed)
            .previewLayout(.sizeThatFits)
    }
}
