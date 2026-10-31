//
//  RecordingSampleList.swift
//  Sensor-App
//

import OSLog
import Sensor_App_Framework
import SwiftUI

/// Loads a recorded session's samples once and lists them.
///
/// Samples of newer sessions are a compressed archive that `SensorSession.load…Samples()` decodes
/// off the main thread, so the list shows a progress indicator until they are ready.
struct RecordingSampleList<Sample, Row: View>: View {

    /// Loads the samples, e.g. `{ try await session.loadMotionSamples() }`.
    let load: () async throws -> [Sample]
    /// Identifies a sample within the session (its counter).
    let id: KeyPath<Sample, Int>
    @ViewBuilder let row: (Sample) -> Row

    @State private var samples: [Sample]?
    @State private var loadFailed = false

    // MARK: - Body
    var body: some View {
        Group {
            if loadFailed {
                ContentUnavailableView("Measurements Could Not Be Loaded", systemImage: "exclamationmark.triangle")
            } else if let samples {
                List(samples, id: id) { sample in
                    row(sample)
                }
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                samples = try await load()
            } catch {
                Logger.recording.error("Loading samples failed: \(error)")
                loadFailed = true
            }
        }
    }
}
