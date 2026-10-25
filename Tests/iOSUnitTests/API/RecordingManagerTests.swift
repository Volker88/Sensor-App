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
