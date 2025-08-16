//
//  MapStyleConfig.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 15.08.25.
//

import MapKit
import SwiftUI

struct MapStyleConfig {

    var baseStyle = BaseMapStyle.standard
    var elevation = MapElevation.flat
    var showTraffic = false

    var mapStyle: MapStyle {
        switch baseStyle {
            case .standard:
                MapStyle.standard(
                    elevation: elevation.selection,
                    showsTraffic: showTraffic)
            case .hybrid:
                MapStyle.hybrid(
                    elevation: elevation.selection,
                    showsTraffic: showTraffic)
            case .imagery:
                MapStyle.imagery(elevation: elevation.selection)
        }
    }
}

// MARK: - Extension
extension MapStyleConfig {
    enum BaseMapStyle: CaseIterable {
        case standard, hybrid, imagery
        var label: LocalizedStringResource {
            switch self {
                case .standard:
                    "Standard"
                case .hybrid:
                    "Satellite with roads"
                case .imagery:
                    "Satellite only"
            }
        }
    }

    enum MapElevation {
        case flat, realistic
        var selection: MapStyle.Elevation {
            switch self {
                case .flat:
                    .flat
                case .realistic:
                    .realistic
            }
        }
    }
}
