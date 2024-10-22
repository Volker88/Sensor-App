//
//  MotionManager.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 24.09.2024.
//

import CoreMotion
import SwiftUI

@MainActor
@Observable
class MotionManager {
    private var motionManager = CMMotionManager()
    private var altimeterManager = CMAltimeter()

    let settings = SettingsManager()

    var motion: MotionModel?
    var motionArray: [MotionModel] = []
    var motionChart: [MotionModel] = []
    var altitude: AltitudeModel?
    var altitudeArray: [AltitudeModel] = []
    var altitudeChart: [AltitudeModel] = []

    var sensorUpdateInterval: Double = 1.0 {
        didSet {
            startMotionUpdates()
            startAltitudeUpdates()
        }
    }

    private var motionCounter = 1
    private var altitudeCounter = 1

    init() {
        mockData()
    }

    // MARK: - Methods
    func startMotionUpdates() {
        motionManager.deviceMotionUpdateInterval = (1.0 / sensorUpdateInterval)
        motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main) { [weak self] data, _ in
            guard let self = self else { return }

            if let data {
                let model = MotionModel(
                    counter: self.motionCounter,
                    timestamp: Date().formatted(),
                    accelerationXAxis: data.userAcceleration.x,
                    accelerationYAxis: data.userAcceleration.y,
                    accelerationZAxis: data.userAcceleration.z,
                    gravityXAxis: data.gravity.x,
                    gravityYAxis: data.gravity.y,
                    gravityZAxis: data.gravity.z,
                    gyroXAxis: data.rotationRate.x,
                    gyroYAxis: data.rotationRate.y,
                    gyroZAxis: data.rotationRate.z,
                    magnetometerCalibration: Int(data.magneticField.accuracy.rawValue),
                    magnetometerXAxis: data.magneticField.field.x,
                    magnetometerYAxis: data.magneticField.field.y,
                    magnetometerZAxis: data.magneticField.field.z,
                    attitudeRoll: data.attitude.roll,
                    attitudePitch: data.attitude.pitch,
                    attitudeYaw: data.attitude.yaw,
                    attitudeHeading: data.heading
                )
                DispatchQueue.main.async {
                    self.motion = model
                    self.motionArray.append(model)
                    self.motionChart.append(model)

                    self.motionCounter += 1

                    if self.motionChart.count > self.settings.fetchUserSettings().graphMaxPointsInt() {
                        self.motionChart.removeFirst()
                    }
                }
            }
        }
    }

    func startAltitudeUpdates() {
        motionManager.deviceMotionUpdateInterval = (1.0 / sensorUpdateInterval)
        altimeterManager.startRelativeAltitudeUpdates(to: .main) { [weak self] data, _ in
            guard let self = self else { return }

            if let data {
                let pressureValue = Double(truncating: data.pressure) // pressure in kPa
                let relativeAltitudeValue = Double(truncating: data.relativeAltitude) // change in m

                let model = AltitudeModel(
                    counter: altitudeCounter,
                    timestamp: Date().formatted(),
                    pressureValue: pressureValue,
                    relativeAltitudeValue: relativeAltitudeValue
                )

                DispatchQueue.main.async {
                    self.altitude = model
                    self.altitudeArray.append(model)
                    self.altitudeChart.append(model)

                    self.altitudeCounter += 1

                    if self.altitudeChart.count > self.settings.fetchUserSettings().graphMaxPointsInt() {
                        self.altitudeChart.removeFirst()
                    }
                }
            }
        }
    }

    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
        altimeterManager.stopRelativeAltitudeUpdates()
    }

    func resetMotionUpdates() {
        motionArray.removeAll()
        motionChart.removeAll()

        altitudeArray.removeAll()
        altitudeChart.removeAll()

        motionCounter = 1
        altitudeCounter = 1
    }

    func mockData() {
#if DEBUG && targetEnvironment(simulator)
        for index in 1...1000 {
                let motion = MotionModel(
                    counter: index,
                    timestamp: Date().formatted(),
                    accelerationXAxis: getDouble(),
                    accelerationYAxis: getDouble(),
                    accelerationZAxis: getDouble(),
                    gravityXAxis: getDouble(),
                    gravityYAxis: getDouble(),
                    gravityZAxis: getDouble(),
                    gyroXAxis: getDouble(),
                    gyroYAxis: getDouble(),
                    gyroZAxis: getDouble(),
                    magnetometerCalibration: Int.random(in: -2...2),
                    magnetometerXAxis: getDouble(),
                    magnetometerYAxis: getDouble(),
                    magnetometerZAxis: getDouble(),
                    attitudeRoll: getDouble(),
                    attitudePitch: getDouble(),
                    attitudeYaw: getDouble(),
                    attitudeHeading: getDouble()
                )
                motionArray.append(motion)
                self.motion = motion

                let altitude = AltitudeModel(
                    counter: index,
                    timestamp: Date().formatted(),
                    pressureValue: Double.random(in: 990...1010),
                    relativeAltitudeValue: Double.random(in: 0...10)
                )

                altitudeArray.append(altitude)
                self.altitude = altitude
            }

        func getDouble() -> Double {
            Double.random(in: -1...1)
        }
#endif
    }
}
