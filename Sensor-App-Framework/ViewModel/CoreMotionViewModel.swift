//
//  CoreMotionViewModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 06.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

class CoreMotionViewModel: ObservableObject {
    @Published var coreMotionArray = [MotionModel]()
    @Published var altitudeArray = [AltitudeModel]()
    @Published var sensorUpdateInterval: Double = 1 {
        didSet {
            motionAPI.sensorUpdateInterval = sensorUpdateInterval
        }
    }

    let motionAPI = CoreMotionAPI()
    let settings = SettingsAPI()
    let debug = false

    init() {
        sensorUpdateInterval = settings.fetchUserSettings().frequencySetting
    }

    // MARK: - onAppear / onDisappear
    func start() {
        motionUpdateStart()
        altitudeUpdateStart()
        sensorUpdateInterval = settings.fetchUserSettings().frequencySetting
    }

    func stop() {
        stopMotionUpdates()
        coreMotionArray.removeAll()
    }

    // MARK: - Methods to Start / Stop
    func motionUpdateStart() {
#if targetEnvironment(simulator)
        mockData()
#endif
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            motionAPI.motionUpdateStart()
            motionAPI.motionCompletionHandler = { [self] data in

                // Append MotionModel to coreMotionArray
                DispatchQueue.main.async { [self] in
                    coreMotionArray.append(
                        MotionModel(
                            counter: coreMotionArray.count + 1,
                            timestamp: settings.getTimestamp(),
                            accelerationXAxis: data.accelerationXAxis,
                            accelerationYAxis: data.accelerationYAxis,
                            accelerationZAxis: data.accelerationZAxis,
                            gravityXAxis: data.gravityXAxis,
                            gravityYAxis: data.gravityYAxis,
                            gravityZAxis: data.gravityZAxis,
                            gyroXAxis: data.gyroXAxis,
                            gyroYAxis: data.gyroYAxis,
                            gyroZAxis: data.gyroZAxis,
                            magnetometerCalibration: data.magnetometerCalibration,
                            magnetometerXAxis: data.magnetometerXAxis,
                            magnetometerYAxis: data.magnetometerYAxis,
                            magnetometerZAxis: data.magnetometerZAxis,
                            attitudeRoll: data.attitudeRoll,
                            attitudePitch: data.attitudePitch,
                            attitudeYaw: data.attitudeYaw,
                            attitudeHeading: data.attitudeHeading
                        )
                    )
                }
            }
        }
    }

    func altitudeUpdateStart() {
#if targetEnvironment(simulator)
        var counter = 1
        for _ in 1...300 {
            let random = Double.random(in: 99...101)
            let random2 = Double.random(in: -1...1)
            altitudeArray.append(
                AltitudeModel(
                    counter: counter,
                    timestamp: settings.getTimestamp(),
                    pressureValue: random,
                    relativeAltitudeValue: random2
                )
            )
            counter += 1
        }

        if debug {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] (_) in
                let random = Double.random(in: 99...101)
                let random2 = Double.random(in: -1...1)
                altitudeArray.append(
                    AltitudeModel(
                        counter: counter,
                        timestamp: settings.getTimestamp(),
                        pressureValue: random,
                        relativeAltitudeValue: random2
                    )
                )
                counter += 1
            }
        }
#endif

        motionAPI.motionUpdateStart()
        motionAPI.altitudeCompletionHandler = { [self] data in

            // Append AltitudeModel to altitudeArray
            altitudeArray.append(AltitudeModel(
                counter: altitudeArray.count + 1,
                timestamp: settings.getTimestamp(),
                pressureValue: data.pressureValue,
                relativeAltitudeValue: data.relativeAltitudeValue
            ))
        }
    }

    func stopMotionUpdates() {
        motionAPI.motionUpdateStop()
    }

    // MARK: - Mock data for Simulator
    func mockData() {
        // swiftlint:disable line_length
        var counter = 1

        for _ in 1...300 {
            let random = Double.random(in: -0.1...0.1)
            let random2 = Double.random(in: -0.1...0.1)
            let random3 = Double.random(in: -0.1...0.1)
            let random4 = Double.random(in: -0.1...0.1)
            coreMotionArray.append(MotionModel(counter: counter, timestamp: settings.getTimestamp(), accelerationXAxis: random, accelerationYAxis: random2, accelerationZAxis: random3, gravityXAxis: random, gravityYAxis: random2, gravityZAxis: random3, gyroXAxis: random, gyroYAxis: random2, gyroZAxis: random3, magnetometerCalibration: 2, magnetometerXAxis: random, magnetometerYAxis: random2, magnetometerZAxis: random3, attitudeRoll: random, attitudePitch: random2, attitudeYaw: random3, attitudeHeading: random4))
            counter += 1
        }

        if debug {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] (_) in
                let random = Double.random(in: -0.1...0.1)
                let random2 = Double.random(in: -0.1...0.1)
                let random3 = Double.random(in: -0.1...0.1)
                let random4 = Double.random(in: -0.1...0.1)
                coreMotionArray.append(MotionModel(counter: counter, timestamp: settings.getTimestamp(), accelerationXAxis: random, accelerationYAxis: random2, accelerationZAxis: random3, gravityXAxis: random, gravityYAxis: random2, gravityZAxis: random3, gyroXAxis: random, gyroYAxis: random2, gyroZAxis: random3, magnetometerCalibration: 2, magnetometerXAxis: random, magnetometerYAxis: random2, magnetometerZAxis: random3, attitudeRoll: random, attitudePitch: random2, attitudeYaw: random3, attitudeHeading: random4))
                counter += 1
            }
        }
        // swiftlint:enable line_length
    }
}
