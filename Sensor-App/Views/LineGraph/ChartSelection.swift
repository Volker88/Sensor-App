//
//  ChartSelection.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 06.07.26.
//  Copyright © 2026 Volker Schmitt. All rights reserved.
//

import Foundation
import Sensor_App_Framework

struct ChartSelection: Identifiable {
    var id: String { "\(graph)-\(detail)" }
    let graph: Graph
    let detail: GraphDetail
    let title: LocalizedStringResource
}
