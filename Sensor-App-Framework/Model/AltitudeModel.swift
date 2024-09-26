//
//  AltitudeModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 03.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

@MainActor
struct AltitudeModel: Hashable {
    let counter: Int
    let timestamp: String
    let pressureValue: Double
    let relativeAltitudeValue: Double
}

extension AltitudeModel {
    func graphValue(for graph: GraphDetail) -> Double {
        switch graph {
            case .pressureValue: return pressureValue
            case .relativeAltitudeValue: return relativeAltitudeValue
            default: return 0
        }
    }

    var calculatedPressure: Double {
        let calculation = CalculationManager()
        let pressureSetting = SettingsManager().fetchUserSettings().pressureSetting

        return calculation.calculatePressure(pressure: pressureValue, to: pressureSetting)
    }

    var pressureUnit: String {
        let pressureSettings = SettingsManager().fetchUserSettings().pressureSetting

        return pressureSettings
    }

    var calculatedAltitude: Double {
        let calculation = CalculationManager()
        let altitudeSetting = SettingsManager().fetchUserSettings().altitudeHeightSetting

        return calculation.calculateHeight(height: relativeAltitudeValue, to: altitudeSetting)
    }

    var altitudeUnit: String {
        let altitudeSetting = SettingsManager().fetchUserSettings().altitudeHeightSetting

        return altitudeSetting
    }
}
