//
//  MotionManager.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 24.09.2024.
//

import CoreMotion
import OSLog
import SwiftUI

@MainActor
@Observable
class MotionManager {
    private var motionManager = CMMotionManager()
    private var altimeterManager = CMAltimeter()

    private let settings = SettingsManager()

    var motion: MotionModel?
    var motionArray: [MotionModel] = []
    var motionChart: [MotionModel] = []
    var altitude: AltitudeModel?
    var altitudeArray: [AltitudeModel] = []
    var altitudeChart: [AltitudeModel] = []
    var authorizationStatus: CMAuthorizationStatus {
        CMMotionActivityManager.authorizationStatus()
    }

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
        requestMotionAccess()
    }

    // MARK: - Methods
    func requestMotionAccess() {
        if CMMotionActivityManager.authorizationStatus() == .notDetermined {
            let activityManager = CMMotionActivityManager()
            activityManager.queryActivityStarting(from: Date(), to: Date(), to: .main) { _, _ in
                // This triggers the permission dialog
            }
        }
    }

    func startMotionUpdates() {

        guard motionManager.isDeviceMotionAvailable else {
            Logger.coreMotion.info("Device motion is not available on this device.")
            return
        }

        guard CMMotionActivityManager.authorizationStatus() == .authorized else {
            Logger.coreMotion.info("Motion data authorization not granted.")
            return
        }

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

                motion = model
                motionArray.append(model)
                motionChart.append(model)

                motionCounter += 1

                if motionChart.count > settings.fetchUserSettings().graphMaxPointsInt() {
                    motionChart.removeFirst()
                }
            }
        }
    }

    func startAltitudeUpdates() {
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            Logger.coreMotion.info("Altimeter not available on this device.")
            return
        }

        guard CMAltimeter.authorizationStatus() == .authorized else {
            Logger.coreMotion.info("Altimeter authorization not granted.")
            return
        }

        motionManager.deviceMotionUpdateInterval = (1.0 / sensorUpdateInterval)
        altimeterManager.startRelativeAltitudeUpdates(to: .main) { [weak self] data, _ in
            guard let self = self else { return }

            if let data {
                let pressureValue = Double(truncating: data.pressure)  // pressure in kPa
                let relativeAltitudeValue = Double(truncating: data.relativeAltitude)  // change in m

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
                motionChart.append(motion)
                self.motion = motion

                let altitude = AltitudeModel(
                    counter: index,
                    timestamp: Date().formatted(),
                    pressureValue: Double.random(in: 990...1010),
                    relativeAltitudeValue: Double.random(in: 0...10)
                )

                altitudeArray.append(altitude)
                altitudeChart.append(altitude)
                self.altitude = altitude
            }

            func getDouble() -> Double {
                Double.random(in: -1...1)
            }
        #endif
    }
}
