//
//  AltitudeModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 03.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

@MainActor
public struct AltitudeModel: Hashable {
    public let counter: Int
    public let timestamp: String
    public let pressureValue: Double
    public let relativeAltitudeValue: Double
}

extension AltitudeModel {
    public func graphValue(for graph: GraphDetail) -> Double {
        switch graph {
            case .pressureValue: return pressureValue
            case .relativeAltitudeValue: return relativeAltitudeValue
            default: return 0
        }
    }

    public var calculatedPressure: Double {
        let calculation = CalculationManager()
        let pressureSetting = SettingsManager().fetchUserSettings().pressureSetting

        return calculation.calculatePressure(pressure: pressureValue, to: pressureSetting)
    }

    public var pressureUnit: String {
        let pressureSettings = SettingsManager().fetchUserSettings().pressureSetting

        return pressureSettings
    }

    public var calculatedAltitude: Double {
        let calculation = CalculationManager()
        let altitudeSetting = SettingsManager().fetchUserSettings().altitudeHeightSetting

        return calculation.calculateHeight(height: relativeAltitudeValue, to: altitudeSetting)
    }

    public var altitudeUnit: String {
        let altitudeSetting = SettingsManager().fetchUserSettings().altitudeHeightSetting

        return altitudeSetting
    }
}
