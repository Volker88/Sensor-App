//
//  MotionManager.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 24.09.2024.
//

import CoreMotion
import OSLog
import SwiftUI

@Observable
public class MotionManager {
    private var motionManager = CMMotionManager()
    private var altimeterManager = CMAltimeter()

    private let settings = SettingsManager()

    /// `true` while device-motion updates are actually being delivered (i.e. the
    /// availability/authorization guards passed). Drives start/pause toggles.
    public private(set) var isMotionRunning: Bool = false
    /// `true` while relative-altitude updates are actually being delivered.
    public private(set) var isAltitudeRunning: Bool = false

    public var motion: MotionModel?
    public var motionArray: [MotionModel] = []
    public var motionChart: [MotionModel] = []
    public var altitude: AltitudeModel?
    public var altitudeArray: [AltitudeModel] = []
    public var altitudeChart: [AltitudeModel] = []
    public var authorizationStatus: CMAuthorizationStatus {
        CMMotionActivityManager.authorizationStatus()
    }

    public var sensorUpdateInterval: Double = 1.0 {
        didSet {
            guard oldValue != sensorUpdateInterval else { return }

            // Only restart streams that are already running, so changing the rate
            // never resumes updates the user paused (or starts sensors nobody asked for).
            if isMotionRunning { startMotionUpdates() }
            if isAltitudeRunning { startAltitudeUpdates() }
        }
    }

    private var motionCounter = 1
    private var altitudeCounter = 1

    // Bridges CMMotionManager/CMAltimeter's closure callbacks into async/await,
    // matching LocationManager's style. CoreMotion delivers both to `.main`, so this
    // never crosses actors — it's structural parity, not a race fix.
    private var motionContinuation: AsyncStream<MotionModel>.Continuation?
    private var altitudeContinuation: AsyncStream<AltitudeModel>.Continuation?

    // Views that currently want each sensor running (see `startMotionUpdates(for:)`).
    // Several screens share this manager, and during navigation the previous screen's
    // onDisappear can fire *after* the next screen's onAppear — tracking owners stops
    // the outgoing screen from tearing down updates the incoming one just started.
    private var motionClients: Set<String> = []
    private var altitudeClients: Set<String> = []

    public init() {
        mockData()
        requestMotionAccess()
    }

    // MARK: - Methods
    public func requestMotionAccess() {
        if CMMotionActivityManager.authorizationStatus() == .notDetermined {
            let activityManager = CMMotionActivityManager()
            activityManager.queryActivityStarting(from: Date(), to: Date(), to: .main) { _, _ in
                // This triggers the permission dialog
            }
        }
    }

    public func startMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            Logger.coreMotion.info("Device motion is not available on this device.")
            return
        }

        guard CMMotionActivityManager.authorizationStatus() == .authorized else {
            Logger.coreMotion.info("Motion data authorization not granted.")
            return
        }

        // Tear down any previous stream first — sensorUpdateInterval's didSet calls this
        // again while updates may already be running, and CMMotionManager just replaces
        // the handler in place, so the old continuation would otherwise never finish.
        stopDeviceMotionUpdates()

        motionManager.deviceMotionUpdateInterval = (1.0 / sensorUpdateInterval)
        let (stream, continuation) = AsyncStream.makeStream(of: MotionModel.self)
        motionContinuation = continuation

        isMotionRunning = true
        motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main) { [weak self] data, _ in
            guard let self, let data else { return }

            let model = MotionModel(
                counter: self.motionCounter,
                timestamp: Date().sensorTimestamp,
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
            self.motionCounter += 1
            continuation.yield(model)
        }

        Task {
            for await model in stream {
                motion = model
                motionArray.append(model)
                motionChart.append(model)

                if motionChart.count > settings.fetchUserSettings().graphMaxPointsInt() {
                    motionChart.removeFirst()
                }
            }
        }
    }

    public func startAltitudeUpdates() {
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            Logger.coreMotion.info("Altimeter not available on this device.")
            return
        }

        guard CMAltimeter.authorizationStatus() == .authorized else {
            Logger.coreMotion.info("Altimeter authorization not granted.")
            return
        }

        // Tear down any previous stream first — see the matching comment in startMotionUpdates().
        stopAltitudeUpdates()

        motionManager.deviceMotionUpdateInterval = (1.0 / sensorUpdateInterval)
        let (stream, continuation) = AsyncStream.makeStream(of: AltitudeModel.self)
        altitudeContinuation = continuation

        isAltitudeRunning = true
        altimeterManager.startRelativeAltitudeUpdates(to: .main) { [weak self] data, _ in
            guard let self, let data else { return }

            let pressureValue = Double(truncating: data.pressure)  // pressure in kPa
            let relativeAltitudeValue = Double(truncating: data.relativeAltitude)  // change in m

            let model = AltitudeModel(
                counter: self.altitudeCounter,
                timestamp: Date().sensorTimestamp,
                pressureValue: pressureValue,
                relativeAltitudeValue: relativeAltitudeValue
            )
            self.altitudeCounter += 1
            continuation.yield(model)
        }

        Task {
            for await model in stream {
                altitude = model
                altitudeArray.append(model)
                altitudeChart.append(model)

                if altitudeChart.count > settings.fetchUserSettings().graphMaxPointsInt() {
                    altitudeChart.removeFirst()
                }
            }
        }
    }

    /// Stops both device-motion and relative-altitude updates.
    public func stopMotionUpdates() {
        stopDeviceMotionUpdates()
        stopAltitudeUpdates()
    }

    /// Stops device-motion updates only (acceleration, gravity, gyroscope, attitude, magnetometer).
    public func stopDeviceMotionUpdates() {
        isMotionRunning = false
        motionManager.stopDeviceMotionUpdates()
        motionContinuation?.finish()
        motionContinuation = nil
    }

    /// Stops relative-altitude updates only.
    public func stopAltitudeUpdates() {
        isAltitudeRunning = false
        altimeterManager.stopRelativeAltitudeUpdates()
        altitudeContinuation?.finish()
        altitudeContinuation = nil
    }

    /// Starts device-motion updates on behalf of `client` (typically a screen).
    /// Pair with `releaseMotionUpdates(for:)`; registering the same client twice is harmless.
    public func startMotionUpdates(for client: String) {
        motionClients.insert(client)
        startMotionUpdates()
    }

    /// Starts relative-altitude updates on behalf of `client`.
    /// Pair with `releaseAltitudeUpdates(for:)`.
    public func startAltitudeUpdates(for client: String) {
        altitudeClients.insert(client)
        startAltitudeUpdates()
    }

    /// Drops `client`'s claim on device motion; updates are stopped and their values
    /// reset once no client needs them anymore.
    public func releaseMotionUpdates(for client: String) {
        motionClients.remove(client)
        guard motionClients.isEmpty else { return }

        stopDeviceMotionUpdates()
        resetDeviceMotionUpdates()
    }

    /// Drops `client`'s claim on relative altitude; see `releaseMotionUpdates(for:)`.
    public func releaseAltitudeUpdates(for client: String) {
        altitudeClients.remove(client)
        guard altitudeClients.isEmpty else { return }

        stopAltitudeUpdates()
        resetAltitudeUpdates()
    }

    /// Clears both device-motion and relative-altitude values.
    public func resetMotionUpdates() {
        resetDeviceMotionUpdates()
        resetAltitudeUpdates()
    }

    /// Clears device-motion values only.
    public func resetDeviceMotionUpdates() {
        motion = nil
        motionArray.removeAll()
        motionChart.removeAll()
        motionCounter = 1
    }

    /// Clears relative-altitude values only.
    public func resetAltitudeUpdates() {
        altitude = nil
        altitudeArray.removeAll()
        altitudeChart.removeAll()
        altitudeCounter = 1
    }

    // MARK: - Statistics
    public func statistics(for detail: GraphDetail) -> AxisStatistics? {
        switch detail {
            case .pressureValue, .relativeAltitudeValue:
                return altitudeArray.map { $0.graphValue(for: detail) }.statistics
            default:
                return motionArray.map { $0.graphValue(for: detail) }.statistics
        }
    }

    public func mockData() {
        #if DEBUG && targetEnvironment(simulator)
            for index in 1...1000 {
                let motion = MotionModel(
                    counter: index,
                    timestamp: Date().sensorTimestamp,
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
                    timestamp: Date().sensorTimestamp,
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
