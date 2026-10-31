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

    /// `true` while a stopped recording is being written to the store. A new recording can't start
    /// until the save has finished.
    public private(set) var isSaving: Bool = false

    public var modelContext: ModelContext? {
        didSet { store = nil }
    }

    private var sessionName: String = ""
    /// When the current (or most recent) recording started. `.distantPast` before the first recording.
    public private(set) var startedAt: Date = .distantPast

    /// Sessions whose deletion has started. Views hide them right away instead of waiting for the
    /// background delete and the `@Query` refresh that follows it. Entries are only removed again if
    /// the delete fails, so a deleted session can never briefly reappear.
    private var pendingDeletions: Set<PersistentIdentifier> = []

    /// Persistence runs on this background actor; it's created lazily for the current context's
    /// container.
    @ObservationIgnored private var store: RecordingStore?

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
        guard !isRecording, !isSaving, modelContext != nil else { return }
        isRecording = true
        startedAt = Date()
        sessionName = name.isEmpty ? defaultName() : name
    }

    /// Ends the recording and saves the session in the background.
    ///
    /// The arrays are value types, so they are a snapshot of the sensor buffers at the time of the
    /// call; the caller can clear the buffers as soon as this returns.
    /// - Returns: `true` if the session was saved, `false` if there was no active recording or the
    ///   save failed (the error is logged).
    @discardableResult
    public func stopRecording(
        motionArray: [MotionModel],
        altitudeArray: [AltitudeModel],
        locationArray: [LocationModel],
        source: String = "iPhone"
    ) async -> Bool {
        guard isRecording, let modelContext else { return false }
        isRecording = false
        isSaving = true
        defer { isSaving = false }

        do {
            try await recordingStore(for: modelContext).saveSession(
                name: sessionName,
                startedAt: startedAt,
                endedAt: Date(),
                source: source,
                motionArray: motionArray,
                altitudeArray: altitudeArray,
                locationArray: locationArray
            )
            return true
        } catch {
            Logger.recording.error("Save failed: \(error)")
            return false
        }
    }

    /// Deletes a session and its measurements in the background. The session counts as deleted for
    /// ``isPendingDeletion(_:)`` immediately.
    /// - Returns: `true` if the session was deleted, `false` if the delete failed (the error is logged).
    @discardableResult
    public func delete(_ session: SensorSession) async -> Bool {
        guard let modelContext else { return false }
        let persistentID = session.persistentModelID
        pendingDeletions.insert(persistentID)

        do {
            try await recordingStore(for: modelContext).deleteSession(id: session.id)
            return true
        } catch {
            pendingDeletions.remove(persistentID)
            Logger.recording.error("Delete failed: \(error)")
            return false
        }
    }

    /// Whether a delete for this session has started. Lists should hide such sessions.
    public func isPendingDeletion(_ session: SensorSession) -> Bool {
        pendingDeletions.contains(session.persistentModelID)
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

    private func recordingStore(for context: ModelContext) -> RecordingStore {
        if let store {
            return store
        }
        let newStore = RecordingStore(modelContainer: context.container)
        store = newStore
        return newStore
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
