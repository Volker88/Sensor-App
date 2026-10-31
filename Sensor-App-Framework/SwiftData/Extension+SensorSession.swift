//
//  Extension+SensorSession.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

extension SensorSession {

    public var duration: TimeInterval? { endedAt.map { $0.timeIntervalSince(startedAt) } }

    public var isCompleted: Bool { endedAt != nil }

    // MARK: - Samples
    //
    // Sessions recorded since schema V2 keep their samples in compressed archives; older sessions
    // keep them as one row per sample. These accessors hide the difference.

    /// Number of motion samples, without decoding the archive.
    public var motionSampleTotal: Int {
        motionSampleCount > 0 ? motionSampleCount : (motionMeasurements?.count ?? 0)
    }

    /// Number of altitude samples, without decoding the archive.
    public var altitudeSampleTotal: Int {
        altitudeSampleCount > 0 ? altitudeSampleCount : (altitudeMeasurements?.count ?? 0)
    }

    /// Number of location samples, without decoding the archive.
    public var locationSampleTotal: Int {
        locationSampleCount > 0 ? locationSampleCount : (locationMeasurements?.count ?? 0)
    }

    /// All motion samples in recording order. Archives are decoded off the main thread.
    public func loadMotionSamples() async throws -> [MotionModel] {
        if motionSampleCount > 0, let archive = motionSampleArchive {
            return try await Self.decodeMotionSamples(archive)
        }
        return (motionMeasurements ?? []).sorted { $0.counter < $1.counter }.map { MotionModel(legacy: $0) }
    }

    /// All altitude samples in recording order. Archives are decoded off the main thread.
    public func loadAltitudeSamples() async throws -> [AltitudeModel] {
        if altitudeSampleCount > 0, let archive = altitudeSampleArchive {
            return try await Self.decodeAltitudeSamples(archive)
        }
        return (altitudeMeasurements ?? []).sorted { $0.counter < $1.counter }.map { AltitudeModel(legacy: $0) }
    }

    /// All location samples in recording order. Archives are decoded off the main thread.
    public func loadLocationSamples() async throws -> [LocationModel] {
        if locationSampleCount > 0, let archive = locationSampleArchive {
            return try await Self.decodeLocationSamples(archive)
        }
        return (locationMeasurements ?? []).sorted { $0.counter < $1.counter }.map { LocationModel(legacy: $0) }
    }

    /// Stores the samples as archives. Used by `RecordingStore` and previews.
    nonisolated func setSamples(motion: [MotionModel], altitude: [AltitudeModel], location: [LocationModel]) throws {
        motionSampleArchive = motion.isEmpty ? nil : try SampleArchive.archive(motion)
        motionSampleCount = motion.count
        altitudeSampleArchive = altitude.isEmpty ? nil : try SampleArchive.archive(altitude)
        altitudeSampleCount = altitude.count
        locationSampleArchive = location.isEmpty ? nil : try SampleArchive.archive(location)
        locationSampleCount = location.count
    }

    @concurrent
    nonisolated private static func decodeMotionSamples(_ archive: Data) async throws -> [MotionModel] {
        try SampleArchive.samples(of: MotionModel.self, from: archive)
    }

    @concurrent
    nonisolated private static func decodeAltitudeSamples(_ archive: Data) async throws -> [AltitudeModel] {
        try SampleArchive.samples(of: AltitudeModel.self, from: archive)
    }

    @concurrent
    nonisolated private static func decodeLocationSamples(_ archive: Data) async throws -> [LocationModel] {
        try SampleArchive.samples(of: LocationModel.self, from: archive)
    }

    // MARK: - Preview

    @MainActor
    public static func mockSession() -> SensorSession {
        let motionManager = MotionManager()
        let locationManager = LocationManager()
        locationManager.mockData(preview: true)

        let session = SensorSession(
            name: "Preview Session",
            startedAt: .now,
            createdAt: .now,
            source: "iPhone"
        )
        try? session.setSamples(
            motion: motionManager.motionArray,
            altitude: motionManager.altitudeArray,
            location: locationManager.locationArray
        )
        return session
    }
}

// MARK: - Legacy rows
//
// Remove with the iOS 28 release, together with `LegacyRecordingConverter`: these helpers, the legacy
// branches of `load…Samples()` and `…SampleTotal` (archive and counts only), and the per-type row
// deletes in `RecordingStore.deleteSession`. The deprecation below turns their uses into compiler
// warnings once the deployment target is iOS/watchOS 28 (see CLAUDE.md, "Known tech debt").

extension MotionModel {
    /// Converts a pre-V2 per-sample row.
    @available(iOS, deprecated: 28.0, message: "Legacy V1 fallback: remove with the iOS 28 release")
    @available(watchOS, deprecated: 28.0, message: "Legacy V1 fallback: remove with the iOS 28 release")
    nonisolated fileprivate init(legacy measurement: MotionMeasurement) {
        self.init(
            counter: measurement.counter,
            timestamp: measurement.timestamp,
            accelerationXAxis: measurement.accelerationXAxis,
            accelerationYAxis: measurement.accelerationYAxis,
            accelerationZAxis: measurement.accelerationZAxis,
            gravityXAxis: measurement.gravityXAxis,
            gravityYAxis: measurement.gravityYAxis,
            gravityZAxis: measurement.gravityZAxis,
            gyroXAxis: measurement.gyroXAxis,
            gyroYAxis: measurement.gyroYAxis,
            gyroZAxis: measurement.gyroZAxis,
            magnetometerCalibration: measurement.magnetometerCalibration,
            magnetometerXAxis: measurement.magnetometerXAxis,
            magnetometerYAxis: measurement.magnetometerYAxis,
            magnetometerZAxis: measurement.magnetometerZAxis,
            attitudeRoll: measurement.attitudeRoll,
            attitudePitch: measurement.attitudePitch,
            attitudeYaw: measurement.attitudeYaw,
            attitudeHeading: measurement.attitudeHeading
        )
    }
}

extension AltitudeModel {
    /// Converts a pre-V2 per-sample row.
    @available(iOS, deprecated: 28.0, message: "Legacy V1 fallback: remove with the iOS 28 release")
    @available(watchOS, deprecated: 28.0, message: "Legacy V1 fallback: remove with the iOS 28 release")
    nonisolated fileprivate init(legacy measurement: AltitudeMeasurement) {
        self.init(
            counter: measurement.counter,
            timestamp: measurement.timestamp,
            pressureValue: measurement.pressureValue,
            relativeAltitudeValue: measurement.relativeAltitudeValue
        )
    }
}

extension LocationModel {
    /// Converts a pre-V2 per-sample row.
    @available(iOS, deprecated: 28.0, message: "Legacy V1 fallback: remove with the iOS 28 release")
    @available(watchOS, deprecated: 28.0, message: "Legacy V1 fallback: remove with the iOS 28 release")
    nonisolated fileprivate init(legacy measurement: LocationMeasurement) {
        self.init(
            counter: measurement.counter,
            longitude: measurement.longitude,
            latitude: measurement.latitude,
            altitude: measurement.altitude,
            speed: measurement.speed,
            course: measurement.course,
            horizontalAccuracy: measurement.horizontalAccuracy,
            verticalAccuracy: measurement.verticalAccuracy,
            timestamp: measurement.timestamp,
            GPSAccuracy: measurement.GPSAccuracy
        )
    }
}
