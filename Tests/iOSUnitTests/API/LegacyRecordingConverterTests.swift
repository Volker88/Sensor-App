//
//  LegacyRecordingConverterTests.swift
//  Sensor-AppiOSUnitTests
//
//  Remove together with `LegacyRecordingConverter` in the iOS 28 release.
//

import Foundation
import SwiftData
import Testing

@testable import Sensor_App_Framework

@MainActor
struct LegacyRecordingConverterTests {

    private static let day: TimeInterval = 24 * 60 * 60

    let container: ModelContainer
    let storeDirectory: URL
    let now = Date.now

    init() throws {
        (container, storeDirectory) = try RecordingTestData.makeOnDiskContainer()
    }

    // MARK: - Conversion
    @Test("A legacy session is converted to archives with identical samples and its rows are removed")
    func convertsLegacySession() async throws {
        defer { try? FileManager.default.removeItem(at: storeDirectory) }
        let context = container.mainContext
        let legacy = try RecordingTestData.insertLegacySession(
            into: context, named: "Legacy", createdAt: now.addingTimeInterval(-120 * Self.day),
            motion: 50, altitude: 4, location: 3
        )
        let sessionID = legacy.id

        let converted = await LegacyRecordingConverter(modelContainer: container).run(now: now)

        // Read through a fresh context, as another screen or device would.
        let reader = ModelContext(container)
        let descriptor = FetchDescriptor<SensorSession>(predicate: #Predicate { $0.id == sessionID })
        let session = try #require(try reader.fetch(descriptor).first)

        #expect(converted == 1)
        #expect(session.motionSampleCount == 50)
        #expect(session.altitudeSampleCount == 4)
        #expect(session.locationSampleCount == 3)
        #expect(try await session.loadMotionSamples() == RecordingTestData.motionModels(count: 50))
        #expect(try await session.loadAltitudeSamples() == RecordingTestData.altitudeModels(count: 4))
        #expect(try await session.loadLocationSamples() == RecordingTestData.locationModels(count: 3))
        #expect(try reader.fetchCount(FetchDescriptor<MotionMeasurement>()) == 0)
        #expect(try reader.fetchCount(FetchDescriptor<AltitudeMeasurement>()) == 0)
        #expect(try reader.fetchCount(FetchDescriptor<LocationMeasurement>()) == 0)
    }

    @Test("All legacy sessions are converted; archived and empty sessions are left alone")
    func convertsOnlyLegacySessions() async throws {
        defer { try? FileManager.default.removeItem(at: storeDirectory) }
        let context = container.mainContext
        let old = now.addingTimeInterval(-200 * Self.day)
        for (name, motion, altitude, location) in [("A", 10, 0, 2), ("B", 0, 3, 0), ("Empty", 0, 0, 0)] {
            try RecordingTestData.insertLegacySession(
                into: context, named: name, createdAt: old, motion: motion, altitude: altitude, location: location
            )
        }
        try await RecordingStore(modelContainer: container).saveSession(
            name: "Archived", startedAt: .now, endedAt: .now, source: "iPhone",
            motionArray: RecordingTestData.motionModels(count: 5), altitudeArray: [], locationArray: []
        )

        let converted = await LegacyRecordingConverter(modelContainer: container).run(now: now)

        let reader = ModelContext(container)
        #expect(converted == 2)
        #expect(try reader.fetchCount(FetchDescriptor<SensorSession>()) == 4)
        #expect(try reader.fetchCount(FetchDescriptor<MotionMeasurement>()) == 0)
        #expect(try reader.fetchCount(FetchDescriptor<AltitudeMeasurement>()) == 0)
        let archived = FetchDescriptor<SensorSession>(predicate: #Predicate { $0.name == "Archived" })
        let session = try #require(try reader.fetch(archived).first)
        #expect(try await session.loadMotionSamples() == RecordingTestData.motionModels(count: 5))
    }

    @Test("A second run finds nothing to convert")
    func secondRunIsANoOp() async throws {
        defer { try? FileManager.default.removeItem(at: storeDirectory) }
        try RecordingTestData.insertLegacySession(
            into: container.mainContext, named: "Legacy", createdAt: now.addingTimeInterval(-100 * Self.day),
            motion: 20, altitude: 2, location: 1
        )
        let converter = LegacyRecordingConverter(modelContainer: container)

        #expect(await converter.run(now: now) == 1)
        #expect(await converter.run(now: now) == 0)
    }

    // MARK: - Gate
    @Test("Nothing is converted while a recent old-format recording shows a pre-V2 device is in use")
    func recentLegacySessionBlocksConversion() async throws {
        defer { try? FileManager.default.removeItem(at: storeDirectory) }
        let context = container.mainContext
        try RecordingTestData.insertLegacySession(
            into: context, named: "Old", createdAt: now.addingTimeInterval(-300 * Self.day),
            motion: 10, altitude: 0, location: 0
        )
        try RecordingTestData.insertLegacySession(
            into: context, named: "Recent", createdAt: now.addingTimeInterval(-10 * Self.day),
            motion: 10, altitude: 0, location: 0
        )

        let converted = await LegacyRecordingConverter(modelContainer: container).run(now: now)

        #expect(converted == 0)
        #expect(try ModelContext(container).fetchCount(FetchDescriptor<MotionMeasurement>()) == 20)
    }

    @Test("The gate opens once the newest old-format recording is older than the window")
    func gateOpensAfterWindow() async throws {
        defer { try? FileManager.default.removeItem(at: storeDirectory) }
        try RecordingTestData.insertLegacySession(
            into: container.mainContext, named: "Recent", createdAt: now.addingTimeInterval(-10 * Self.day),
            motion: 10, altitude: 0, location: 0
        )
        let converter = LegacyRecordingConverter(modelContainer: container)

        #expect(await converter.run(now: now) == 0)
        #expect(await converter.run(now: now.addingTimeInterval(81 * Self.day)) == 1)
    }
}
