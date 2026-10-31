//
//  RecordingTestData.swift
//  Sensor-AppiOSUnitTests
//

import Foundation
import SwiftData

@testable import Sensor_App_Framework

/// Builds synthetic sensor samples and stores for recording tests. Values are derived from the counter so
/// every sample is distinct.
@MainActor
enum RecordingTestData {

    private static let timestamp = "2026-10-25 12:00:00.000"

    /// Builds a container with the production schema and migration plan, backed by a SQLite file in
    /// a fresh temporary directory that the caller removes after the test. CloudKit is disabled.
    static func makeOnDiskContainer() throws -> (ModelContainer, URL) {
        let storeDirectory = URL.temporaryDirectory.appending(path: UUID().uuidString, directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: storeDirectory, withIntermediateDirectories: true)

        let schema = Schema(versionedSchema: LatestModelSchema.self)
        let configuration = ModelConfiguration(
            schema: schema,
            url: storeDirectory.appending(path: "Recording.store"),
            cloudKitDatabase: .none
        )
        let container = try ModelContainer(
            for: schema,
            migrationPlan: DatabaseMigrationPlan.self,
            configurations: configuration
        )
        return (container, storeDirectory)
    }

    /// Stores a session the way schema V1 did: one row per sample, inserted in reverse order so tests
    /// also check that reading sorts by counter.
    @discardableResult
    static func insertLegacySession(
        into context: ModelContext,
        named name: String,
        createdAt: Date = .now,
        motion: Int,
        altitude: Int,
        location: Int
    ) throws -> SensorSession {
        let legacy = SensorSession(
            name: name, startedAt: createdAt, endedAt: createdAt, createdAt: createdAt, source: "iPhone"
        )
        context.insert(legacy)
        for model in motionModels(count: motion).reversed() {
            context.insert(MotionMeasurement(from: model, session: legacy))
        }
        for model in altitudeModels(count: altitude).reversed() {
            context.insert(AltitudeMeasurement(from: model, session: legacy))
        }
        for model in locationModels(count: location).reversed() {
            context.insert(LocationMeasurement(from: model, session: legacy))
        }
        try context.save()
        return legacy
    }

    static func motionModels(count: Int) -> [MotionModel] {
        (1..<count + 1).map { counter in
            let value = Double(counter)
            return MotionModel(
                counter: counter,
                timestamp: timestamp,
                accelerationXAxis: value,
                accelerationYAxis: value,
                accelerationZAxis: value,
                gravityXAxis: value,
                gravityYAxis: value,
                gravityZAxis: value,
                gyroXAxis: value,
                gyroYAxis: value,
                gyroZAxis: value,
                magnetometerCalibration: 2,
                magnetometerXAxis: value,
                magnetometerYAxis: value,
                magnetometerZAxis: value,
                attitudeRoll: value,
                attitudePitch: value,
                attitudeYaw: value,
                attitudeHeading: value
            )
        }
    }

    static func altitudeModels(count: Int) -> [AltitudeModel] {
        (1..<count + 1).map { counter in
            AltitudeModel(
                counter: counter,
                timestamp: timestamp,
                pressureValue: 101.3,
                relativeAltitudeValue: Double(counter)
            )
        }
    }

    static func locationModels(count: Int) -> [LocationModel] {
        (1..<count + 1).map { counter in
            LocationModel(
                counter: counter,
                longitude: 8.68,
                latitude: 50.11,
                altitude: 100,
                speed: 1.5,
                course: 90,
                horizontalAccuracy: 5,
                verticalAccuracy: 3,
                timestamp: timestamp,
                GPSAccuracy: 5
            )
        }
    }
}
