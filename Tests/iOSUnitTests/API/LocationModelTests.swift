//
//  LocationModelTests.swift
//  Sensor-AppTests
//

import Foundation
import Testing

@testable import Sensor_App
@testable import Sensor_App_Framework

@MainActor
final class LocationModelTests: BaseTestCase {

    private func makeModel(horizontalAccuracy: Double = 10.0, verticalAccuracy: Double = 5.0) -> LocationModel {
        LocationModel(
            counter: 1,
            longitude: 0,
            latitude: 0,
            altitude: 100,
            speed: 0,
            course: 0,
            horizontalAccuracy: horizontalAccuracy,
            verticalAccuracy: verticalAccuracy,
            timestamp: "",
            GPSAccuracy: 0
        )
    }

    @Test(
        "calculatedHorizontalAccuracy converts from meters using locationAccuracySetting",
        arguments: [
            (unit: UnitLength.meters.symbol, input: 10.0, expected: 10.0),
            (unit: UnitLength.feet.symbol, input: 1.0, expected: 3.28),
            (unit: UnitLength.centimeters.symbol, input: 1.0, expected: 100.0)
        ])
    func calculatedHorizontalAccuracy(unit: String, input: Double, expected: Double) throws {
        var settings = settingsManager.fetchUserSettings()
        settings.locationAccuracySetting = unit
        settingsManager.saveUserSettings(userSettings: settings)

        let model = makeModel(horizontalAccuracy: input)
        let result = model.calculatedHorizontalAccuracy.rounded(toPlaces: 2)

        #expect(result == expected, "\(input) m horizontal accuracy should equal \(expected) \(unit)")
    }

    @Test(
        "calculatedVerticalAccuracy converts from meters using altitudeHeightSetting",
        arguments: [
            (unit: UnitLength.meters.symbol, input: 5.0, expected: 5.0),
            (unit: UnitLength.feet.symbol, input: 1.0, expected: 3.28),
            (unit: UnitLength.centimeters.symbol, input: 1.0, expected: 100.0)
        ])
    func calculatedVerticalAccuracy(unit: String, input: Double, expected: Double) throws {
        var settings = settingsManager.fetchUserSettings()
        settings.altitudeHeightSetting = unit
        settingsManager.saveUserSettings(userSettings: settings)

        let model = makeModel(verticalAccuracy: input)
        let result = model.calculatedVerticalAccuracy.rounded(toPlaces: 2)

        #expect(result == expected, "\(input) m vertical accuracy should equal \(expected) \(unit)")
    }

    @Test(
        "horizontalAccuracyUnit reflects the active locationAccuracySetting",
        arguments: [UnitLength.meters.symbol, UnitLength.feet.symbol, UnitLength.yards.symbol])
    func horizontalAccuracyUnit(unit: String) throws {
        var settings = settingsManager.fetchUserSettings()
        settings.locationAccuracySetting = unit
        settingsManager.saveUserSettings(userSettings: settings)

        #expect(makeModel().horizontalAccuracyUnit == unit)
    }
}
