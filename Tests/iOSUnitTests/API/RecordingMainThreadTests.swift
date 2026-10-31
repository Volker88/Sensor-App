//
//  RecordingMainThreadTests.swift
//  Sensor-AppiOSUnitTests
//

import Foundation
import SwiftData
import Testing

@testable import Sensor_App_Framework

/// Checks that stopping a large recording never stalls the main thread.
///
/// A ticker on the main actor wakes up every few milliseconds and records the longest gap between
/// two ticks. Any synchronous main-thread work (inserting, saving, merging the background save into
/// the main context) shows up as a long gap. The phase timestamps make it visible where it happens.
@MainActor
@Suite("Recording main-thread responsiveness", .serialized)
struct RecordingMainThreadTests {

    // Roughly five minutes of motion data at 100 Hz.
    private static let motionSampleCount = 30_000

    @Test("Stopping a large recording keeps the main thread responsive")
    func stopRecordingKeepsMainThreadResponsive() async throws {
        let (container, storeDirectory) = try RecordingTestData.makeOnDiskContainer()
        defer { try? FileManager.default.removeItem(at: storeDirectory) }
        let recordingManager = RecordingManager(modelContext: container.mainContext)

        let motionArray = RecordingTestData.motionModels(count: Self.motionSampleCount)
        let altitudeArray = RecordingTestData.altitudeModels(count: 300)
        let locationArray = RecordingTestData.locationModels(count: 300)

        let clock = ContinuousClock()
        let start = clock.now

        // Runs until cancelled and returns its measurements, so it captures no mutable state.
        let ticker = Task { @MainActor in
            var longestGap: Duration = .zero
            var longestGapEndedAt: Duration = .zero
            var last = clock.now
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(5))
                let now = clock.now
                if now - last > longestGap {
                    longestGap = now - last
                    longestGapEndedAt = now - start
                }
                last = now
            }
            return (longestGap: longestGap, longestGapEndedAt: longestGapEndedAt)
        }

        recordingManager.startRecording(name: "Main thread")
        let saved = await recordingManager.stopRecording(
            motionArray: motionArray,
            altitudeArray: altitudeArray,
            locationArray: locationArray
        )
        let saveFinishedAt = clock.now - start

        // Give the main context time to merge the background save, as it would in the app.
        try await Task.sleep(for: .seconds(2))
        ticker.cancel()
        let (longestGap, longestGapEndedAt) = await ticker.value

        let style = Duration.UnitsFormatStyle(allowedUnits: [.seconds, .milliseconds], width: .abbreviated)
        let summary = """
            save finished after \(saveFinishedAt.formatted(style)); \
            longest main-thread gap \(longestGap.formatted(style)), ending at \(longestGapEndedAt.formatted(style))
            """
        print(summary)
        Attachment.record(summary, named: "main-thread-gaps.txt")

        #expect(saved)
        #expect(longestGap < .milliseconds(250), "Main thread stalled: \(summary)")
    }
}
