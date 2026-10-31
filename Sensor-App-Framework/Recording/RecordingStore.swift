//
//  RecordingStore.swift
//  Sensor-App-Framework
//

import Foundation
import SwiftData

/// Background persistence for recordings, so saving or deleting a large session never blocks the
/// main thread.
///
/// It shares the app's `ModelContainer`, so the main context (and every `@Query`) picks up its saves
/// automatically, and CloudKit mirroring sees them like any other save.
///
/// This is deliberately a plain actor rather than a `@ModelActor`. The macro's
/// `DefaultSerialModelExecutor` runs each job on the thread that enqueued it, so every call from the
/// main actor ran the whole save on the main thread. A plain actor always runs on the cooperative
/// thread pool, and each operation uses its own short-lived `ModelContext`.
public actor RecordingStore {

    private let modelContainer: ModelContainer

    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    /// Saves a session with all of its samples in a single transaction, so the session only shows up
    /// once it is complete.
    ///
    /// Each sensor's samples are stored as one compressed archive on the session (see
    /// `SampleArchive`), not as one row per sample. Linking tens of thousands of rows to a session is
    /// what made saving a long recording take minutes on device.
    public func saveSession(  // swiftlint:disable:this function_parameter_count
        name: String,
        startedAt: Date,
        endedAt: Date,
        source: String,
        motionArray: [MotionModel],
        altitudeArray: [AltitudeModel],
        locationArray: [LocationModel]
    ) throws {
        let session = SensorSession(
            name: name,
            startedAt: startedAt,
            endedAt: endedAt,
            createdAt: .now,
            source: source
        )
        try session.setSamples(motion: motionArray, altitude: altitudeArray, location: locationArray)

        // If this throws, the context (and its unsaved insert) is simply discarded.
        let context = makeContext()
        context.insert(session)
        try context.save()
    }

    /// Deletes a session and all of its samples.
    ///
    /// Archived samples go with the session. Sessions recorded before schema V2 also have one row per
    /// sample; those are removed with one predicate-based delete per type, instead of letting the
    /// cascade rule load and delete them one at a time.
    /// - Parameter sessionID: The session's `id` (not its `persistentModelID`), so the predicates
    ///   compare a plain attribute through the to-one relationship.
    public func deleteSession(id sessionID: UUID) throws {
        let context = makeContext()
        // Legacy V1 rows: remove these three deletes with the iOS 28 release (see CLAUDE.md).
        try context.delete(
            model: MotionMeasurement.self,
            where: #Predicate { $0.session?.id == sessionID }
        )
        try context.delete(
            model: AltitudeMeasurement.self,
            where: #Predicate { $0.session?.id == sessionID }
        )
        try context.delete(
            model: LocationMeasurement.self,
            where: #Predicate { $0.session?.id == sessionID }
        )
        try context.delete(
            model: SensorSession.self,
            where: #Predicate { $0.id == sessionID }
        )
        try context.save()
    }

    /// A fresh context per operation: nothing from a failed operation can leak into the next one.
    private func makeContext() -> ModelContext {
        let context = ModelContext(modelContainer)
        context.autosaveEnabled = false
        return context
    }
}
