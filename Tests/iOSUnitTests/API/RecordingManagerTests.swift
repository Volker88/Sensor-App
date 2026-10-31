//
//  RecordingManagerTests.swift
//  Sensor-AppiOSUnitTests
//

import Foundation
import Sensor_App_Framework
import SwiftData
import Testing

@testable import Sensor_App

@MainActor
final class RecordingManagerTests: BaseTestCase {

    // Held for the lifetime of the test: once the container deallocates, its context is reset and
    // every model instance inserted into it becomes unusable.
    let container: ModelContainer
    let recordingManager: RecordingManager
    let session: SensorSession

    // MARK: - Setup
    override init() async throws {
        container = try #require(SwiftDataContainer(inMemory: true).modelContainer)
        let context = container.mainContext

        session = SensorSession(
            name: "Original Name", startedAt: .now, endedAt: .now, createdAt: .now, source: "iPhone"
        )
        context.insert(session)
        try context.save()

        recordingManager = RecordingManager(modelContext: context)
        try await super.init()
    }

    // MARK: - Testing Methods
    @Test("Rename stores the new name")
    func renameSession() {
        let didRename = recordingManager.rename(session, to: "Bike ride Rhine")

        #expect(didRename)
        #expect(session.name == "Bike ride Rhine")
    }

    @Test("Rename trims leading and trailing whitespace")
    func renameTrimsWhitespace() {
        let didRename = recordingManager.rename(session, to: "  Elevator test \n")

        #expect(didRename)
        #expect(session.name == "Elevator test")
    }

    @Test("Rename rejects empty input and keeps the previous name", arguments: ["", "   ", "\n\t"])
    func renameRejectsEmptyInput(newName: String) {
        let didRename = recordingManager.rename(session, to: newName)

        #expect(!didRename)
        #expect(session.name == "Original Name")
    }

    @Test("Rename without a model context is rejected")
    func renameWithoutContext() {
        let managerWithoutContext = RecordingManager()

        #expect(!managerWithoutContext.rename(session, to: "New Name"))
        #expect(session.name == "Original Name")
    }

    @Test("Stop recording saves all samples as archives on the session")
    func stopRecordingSavesSamples() async throws {
        let motion = RecordingTestData.motionModels(count: 100)
        let altitude = RecordingTestData.altitudeModels(count: 10)
        let location = RecordingTestData.locationModels(count: 5)

        recordingManager.startRecording(name: "Bike ride Rhine")
        let didSave = await recordingManager.stopRecording(
            motionArray: motion,
            altitudeArray: altitude,
            locationArray: location,
            source: "Apple Watch"
        )

        let context = container.mainContext
        let descriptor = FetchDescriptor<SensorSession>(predicate: #Predicate { $0.name == "Bike ride Rhine" })
        let saved = try #require(try context.fetch(descriptor).first)

        #expect(didSave)
        #expect(!recordingManager.isRecording)
        #expect(!recordingManager.isSaving)
        #expect(saved.source == "Apple Watch")
        #expect(saved.motionSampleTotal == 100)
        #expect(saved.altitudeSampleTotal == 10)
        #expect(saved.locationSampleTotal == 5)
        #expect(try await saved.loadMotionSamples() == motion)
        #expect(try await saved.loadAltitudeSamples() == altitude)
        #expect(try await saved.loadLocationSamples() == location)
        // No per-sample rows any more.
        #expect(try context.fetchCount(FetchDescriptor<MotionMeasurement>()) == 0)
        #expect(try context.fetchCount(FetchDescriptor<AltitudeMeasurement>()) == 0)
        #expect(try context.fetchCount(FetchDescriptor<LocationMeasurement>()) == 0)
    }

    @Test("A sensor without samples stores no archive")
    func stopRecordingWithoutSamples() async throws {
        recordingManager.startRecording(name: "Motion only")
        await recordingManager.stopRecording(
            motionArray: RecordingTestData.motionModels(count: 3),
            altitudeArray: [],
            locationArray: []
        )

        let descriptor = FetchDescriptor<SensorSession>(predicate: #Predicate { $0.name == "Motion only" })
        let saved = try #require(try container.mainContext.fetch(descriptor).first)

        #expect(saved.altitudeSampleArchive == nil)
        #expect(saved.altitudeSampleTotal == 0)
        #expect(try await saved.loadAltitudeSamples().isEmpty)
        #expect(saved.locationSampleArchive == nil)
        #expect(try await saved.loadLocationSamples().isEmpty)
    }

    @Test("Stop recording without an active recording saves nothing")
    func stopRecordingWhenIdle() async throws {
        let didSave = await recordingManager.stopRecording(
            motionArray: RecordingTestData.motionModels(count: 10),
            altitudeArray: [],
            locationArray: []
        )

        let context = container.mainContext
        #expect(!didSave)
        #expect(try context.fetchCount(FetchDescriptor<SensorSession>()) == 1)
        #expect(try context.fetchCount(FetchDescriptor<MotionMeasurement>()) == 0)
    }

    @Test("A new recording can't start while the previous one is still saving")
    func startRecordingBlockedWhileSaving() async throws {
        recordingManager.startRecording(name: "First")
        let save = Task {
            await recordingManager.stopRecording(
                motionArray: RecordingTestData.motionModels(count: 1_000),
                altitudeArray: [],
                locationArray: []
            )
        }
        while !recordingManager.isSaving {
            await Task.yield()
        }

        recordingManager.startRecording(name: "Second")
        #expect(!recordingManager.isRecording)

        #expect(await save.value)
        #expect(!recordingManager.isSaving)
        recordingManager.startRecording(name: "Second")
        #expect(recordingManager.isRecording)
    }

    @Test("Delete removes a session with archived samples")
    func deleteRemovesArchivedSession() async throws {
        recordingManager.startRecording(name: "To Delete")
        await recordingManager.stopRecording(
            motionArray: RecordingTestData.motionModels(count: 100),
            altitudeArray: RecordingTestData.altitudeModels(count: 10),
            locationArray: RecordingTestData.locationModels(count: 5)
        )

        let context = container.mainContext
        let descriptor = FetchDescriptor<SensorSession>(predicate: #Predicate { $0.name == "To Delete" })
        let saved = try #require(try context.fetch(descriptor).first)

        #expect(await recordingManager.delete(saved))

        // Only the session from `init` remains.
        #expect(try context.fetchCount(FetchDescriptor<SensorSession>()) == 1)
        #expect(try context.fetch(descriptor).isEmpty)
    }

    @Test("Delete removes a pre-V2 session and all of its per-sample rows")
    func deleteRemovesLegacySession() async throws {
        let legacy = try RecordingTestData.insertLegacySession(
            into: container.mainContext, named: "Legacy", motion: 100, altitude: 10, location: 5
        )

        #expect(await recordingManager.delete(legacy))

        let context = container.mainContext
        #expect(try context.fetchCount(FetchDescriptor<SensorSession>()) == 1)
        #expect(try context.fetchCount(FetchDescriptor<MotionMeasurement>()) == 0)
        #expect(try context.fetchCount(FetchDescriptor<AltitudeMeasurement>()) == 0)
        #expect(try context.fetchCount(FetchDescriptor<LocationMeasurement>()) == 0)
    }

    @Test("Delete keeps the per-sample rows of other pre-V2 sessions")
    func deleteKeepsOtherLegacySessions() async throws {
        try RecordingTestData.insertLegacySession(
            into: container.mainContext, named: "Keep", motion: 20, altitude: 5, location: 2
        )
        let toDelete = try RecordingTestData.insertLegacySession(
            into: container.mainContext, named: "Delete", motion: 20, altitude: 5, location: 2
        )

        #expect(await recordingManager.delete(toDelete))

        let context = container.mainContext
        #expect(try context.fetchCount(FetchDescriptor<MotionMeasurement>()) == 20)
        #expect(try context.fetchCount(FetchDescriptor<AltitudeMeasurement>()) == 5)
        #expect(try context.fetchCount(FetchDescriptor<LocationMeasurement>()) == 2)
    }

    @Test("A pre-V2 session's samples load from its rows, in recording order")
    func loadLegacySamples() async throws {
        let legacy = try RecordingTestData.insertLegacySession(
            into: container.mainContext, named: "Legacy", motion: 50, altitude: 4, location: 3
        )

        #expect(legacy.motionSampleTotal == 50)
        #expect(legacy.altitudeSampleTotal == 4)
        #expect(legacy.locationSampleTotal == 3)
        #expect(try await legacy.loadMotionSamples() == RecordingTestData.motionModels(count: 50))
        #expect(try await legacy.loadAltitudeSamples() == RecordingTestData.altitudeModels(count: 4))
        #expect(try await legacy.loadLocationSamples() == RecordingTestData.locationModels(count: 3))
    }

    @Test("A session counts as deleted as soon as the delete starts")
    func deleteHidesSessionImmediately() async throws {
        let delete = Task { await recordingManager.delete(session) }
        while !recordingManager.isPendingDeletion(session) {
            await Task.yield()
        }

        #expect(await delete.value)
        // Deleted sessions stay hidden, so the row can't flash back before `@Query` refreshes.
        #expect(recordingManager.isPendingDeletion(session))
    }

    @Test("The recording store does its work off the main thread")
    func storeRunsOffMainThread() async {
        let store = RecordingStore(modelContainer: container)

        // Await outside `#expect`: its closure isn't main-actor isolated, so a call made inside it
        // would be enqueued from a background thread and hide an executor that runs work inline.
        let ranOnMainThread = await store.isRunningOnMainThread()
        #expect(!ranOnMainThread)
    }

    @Test(
        "Export filename replaces reserved characters",
        arguments: [
            ("18 Oct 2026, 09:14", "18 Oct 2026, 09-14"),
            ("Bike/ride\\Rhine", "Bike-ride-Rhine"),
            ("Elevator test", "Elevator test"),
            ("..hidden", "hidden"),
            ("", "export")
        ]
    )
    func sanitizedFilename(input: String, expected: String) {
        #expect(ExportManager.sanitizedFilename(input) == expected)
    }
}

// MARK: - Helpers
extension RecordingStore {
    /// Reports which thread the actor's work runs on when called from the main actor.
    fileprivate func isRunningOnMainThread() -> Bool {
        Thread.isMainThread
    }
}
