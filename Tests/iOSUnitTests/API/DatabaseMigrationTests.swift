//
//  DatabaseMigrationTests.swift
//  Sensor-AppiOSUnitTests
//

import Foundation
import SwiftData
import Testing

@testable import Sensor_App_Framework

/// Opens a store written with schema V1 through `DatabaseMigrationPlan`, the way an app update does.
@MainActor
struct DatabaseMigrationTests {

    @Test("A V1 store migrates to V2 and its sessions stay readable")
    func migrateV1ToV2() async throws {
        let storeDirectory = URL.temporaryDirectory.appending(path: UUID().uuidString, directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: storeDirectory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: storeDirectory) }
        let storeURL = storeDirectory.appending(path: "Migration.store")

        try writeV1Store(at: storeURL)

        let schema = Schema(versionedSchema: ModelsSchemaV2.self)
        let container = try ModelContainer(
            for: schema,
            migrationPlan: DatabaseMigrationPlan.self,
            configurations: ModelConfiguration(schema: schema, url: storeURL, cloudKitDatabase: .none)
        )
        let context = container.mainContext
        let session = try #require(try context.fetch(FetchDescriptor<SensorSession>()).first)

        #expect(session.name == "Recorded with V1")
        #expect(session.source == "Apple Watch")
        #expect(session.motionSampleArchive == nil)
        #expect(session.motionSampleCount == 0)
        #expect(session.motionSampleTotal == 30)
        #expect(session.altitudeSampleTotal == 3)
        #expect(try await session.loadMotionSamples() == RecordingTestData.motionModels(count: 30))
        #expect(try await session.loadAltitudeSamples() == RecordingTestData.altitudeModels(count: 3))

        // New recordings are saved as archives next to the migrated rows.
        try await RecordingStore(modelContainer: container).saveSession(
            name: "Recorded with V2", startedAt: .now, endedAt: .now, source: "iPhone",
            motionArray: RecordingTestData.motionModels(count: 10), altitudeArray: [], locationArray: []
        )
        let descriptor = FetchDescriptor<SensorSession>(predicate: #Predicate { $0.name == "Recorded with V2" })
        let newSession = try #require(try context.fetch(descriptor).first)
        #expect(try await newSession.loadMotionSamples() == RecordingTestData.motionModels(count: 10))
        #expect(try context.fetchCount(FetchDescriptor<MotionMeasurement>()) == 30)
    }

    /// Writes a store with the V1 schema and closes it again before returning.
    private func writeV1Store(at url: URL) throws {
        let schema = Schema(versionedSchema: ModelsSchemaV1.self)
        let container = try ModelContainer(
            for: schema,
            configurations: ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .none)
        )
        let context = ModelContext(container)
        let session = ModelsSchemaV1.SensorSession(
            name: "Recorded with V1", startedAt: .now, endedAt: .now, createdAt: .now, source: "Apple Watch"
        )
        context.insert(session)
        for model in RecordingTestData.motionModels(count: 30) {
            context.insert(ModelsSchemaV1.MotionMeasurement(from: model, session: session))
        }
        for model in RecordingTestData.altitudeModels(count: 3) {
            context.insert(ModelsSchemaV1.AltitudeMeasurement(from: model, session: session))
        }
        try context.save()
    }
}
