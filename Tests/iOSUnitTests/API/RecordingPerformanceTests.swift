//
//  RecordingPerformanceTests.swift
//  Sensor-AppiOSUnitTests
//

import SwiftData
import XCTest

@testable import Sensor_App_Framework

/// Benchmarks saving and deleting a large recording session through `RecordingManager`.
///
/// These use XCTest because Swift Testing has no performance metrics or baselines; set a baseline
/// in Xcode's test report to catch regressions. Whether the save and delete store the right data is
/// checked separately in `RecordingManagerTests` (Swift Testing).
///
/// Both tests run against an on-disk SQLite store in a temporary directory instead of an in-memory
/// store, so the cost of writing to the file and cascading the delete is close to a real device.
/// CloudKit is disabled; only local persistence is measured.
///
/// Persistence runs on the background `RecordingStore`, so each measured section waits for the
/// async call to finish. The numbers are the total time of the save or delete, comparable with the
/// baseline taken while it still ran on the main context. That the work no longer blocks the main
/// thread is checked in `RecordingManagerTests`.
@MainActor
final class RecordingPerformanceTests: XCTestCase {

    // About 50 seconds of motion data at 100 Hz, plus one altitude and location sample per second
    // over roughly 8 minutes.
    private static let motionSampleCount = 5_000
    private static let altitudeSampleCount = 500
    private static let locationSampleCount = 500

    // Lazy so they are built on the main actor inside the test, not in XCTestCase's nonisolated init.
    private lazy var motionArray = RecordingTestData.motionModels(count: Self.motionSampleCount)
    private lazy var altitudeArray = RecordingTestData.altitudeModels(count: Self.altitudeSampleCount)
    private lazy var locationArray = RecordingTestData.locationModels(count: Self.locationSampleCount)

    private var metrics: [any XCTMetric] {
        [XCTClockMetric(), XCTCPUMetric(), XCTMemoryMetric()]
    }

    private var manualMeasureOptions: XCTMeasureOptions {
        let options = XCTMeasureOptions()
        options.invocationOptions = [.manuallyStart, .manuallyStop]
        return options
    }

    // MARK: - Testing Methods
    func testStopRecordingPerformance() throws {
        let (container, storeDirectory) = try RecordingTestData.makeOnDiskContainer()
        defer { try? FileManager.default.removeItem(at: storeDirectory) }
        let recordingManager = RecordingManager(modelContext: container.mainContext)

        measure(metrics: metrics, options: manualMeasureOptions) {
            recordingManager.startRecording(name: "Performance")

            startMeasuring()
            waitFor { await self.stopRecording(with: recordingManager) }
            stopMeasuring()
        }
    }

    func testDeleteSessionPerformance() throws {
        let (container, storeDirectory) = try RecordingTestData.makeOnDiskContainer()
        defer { try? FileManager.default.removeItem(at: storeDirectory) }
        let context = container.mainContext
        let recordingManager = RecordingManager(modelContext: context)

        measure(metrics: metrics, options: manualMeasureOptions) {
            // Seed a fresh session for every iteration; only the delete is measured.
            recordingManager.startRecording(name: "Performance")
            waitFor { await self.stopRecording(with: recordingManager) }
            guard let session = try? context.fetch(FetchDescriptor<SensorSession>()).first else {
                XCTFail("Seeding the session failed")
                return
            }

            startMeasuring()
            waitFor { await recordingManager.delete(session) }
            stopMeasuring()
        }
    }

    // MARK: - Helpers
    private func stopRecording(with recordingManager: RecordingManager) async {
        await recordingManager.stopRecording(
            motionArray: motionArray,
            altitudeArray: altitudeArray,
            locationArray: locationArray
        )
    }

    /// Runs async work to completion from the synchronous `measure` block. `wait(for:)` keeps the
    /// main run loop turning, so main-actor work inside the operation still runs.
    private func waitFor(_ operation: @escaping () async -> Void) {
        let finished = expectation(description: "Operation finished")
        Task {
            await operation()
            finished.fulfill()
        }
        wait(for: [finished], timeout: 120)
    }
}
