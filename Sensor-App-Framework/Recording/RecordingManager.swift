//
//  RecordingManager.swift
//  Sensor-App-Framework
//

import Foundation
import OSLog
import SwiftData

@Observable
public class RecordingManager {
    public var isRecording: Bool = false
    public var modelContext: ModelContext?

    private var sessionName: String = ""
    /// When the current (or most recent) recording started. `.distantPast` before the first recording.
    public private(set) var startedAt: Date = .distantPast

    public init(
        isRecording: Bool = false, modelContext: ModelContext? = nil, sessionName: String = "",
        startedAt: Date = .distantPast
    ) {
        self.isRecording = isRecording
        self.modelContext = modelContext
        self.sessionName = sessionName
        self.startedAt = startedAt
    }

    public func startRecording(name: String = "") {
        guard !isRecording, modelContext != nil else { return }
        isRecording = true
        startedAt = Date()
        sessionName = name.isEmpty ? defaultName() : name
    }

    public func stopRecording(
        motionArray: [MotionModel],
        altitudeArray: [AltitudeModel],
        locationArray: [LocationModel],
        source: String = "iPhone"
    ) {
        guard isRecording, let context = modelContext else { return }
        isRecording = false

        let session = SensorSession(
            name: sessionName,
            startedAt: startedAt,
            endedAt: Date(),
            createdAt: Date(),
            source: source
        )

        context.insert(session)

        for motionModel in motionArray {
            let measurement = MotionMeasurement(from: motionModel, session: session)
            context.insert(measurement)
        }

        for altitudeModel in altitudeArray {
            let measurement = AltitudeMeasurement(from: altitudeModel, session: session)
            context.insert(measurement)
        }

        for locationModel in locationArray {
            let measurement = LocationMeasurement(from: locationModel, session: session)
            context.insert(measurement)
        }

        save(context)
    }

    public func delete(_ session: SensorSession) {
        guard let context = modelContext else { return }
        context.delete(session)
        save(context)
    }

    /// Renames a saved session.
    ///
    /// Leading and trailing whitespace is trimmed. An empty (or whitespace-only) name is rejected and
    /// the session keeps its previous name.
    /// - Returns: `true` if the session now carries the trimmed name, `false` if the input was rejected.
    @discardableResult
    public func rename(_ session: SensorSession, to newName: String) -> Bool {
        guard let context = modelContext else { return false }
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return false }
        guard trimmedName != session.name else { return true }

        session.name = trimmedName
        save(context)
        return true
    }

    private func save(_ context: ModelContext) {
        do {
            try context.save()
        } catch {
            Logger.recording.error("Save failed: \(error)")
        }
    }

    private func defaultName() -> String {
        Date.now.formatted(date: .abbreviated, time: .shortened)
    }
}
