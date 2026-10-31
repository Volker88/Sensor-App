//
//  LegacyRecordingConverter.swift
//  Sensor-App-Framework
//

import Foundation
import OSLog
import SwiftData

/// One-time conversion of recordings made before schema V2 (one row per sample) into sample archives.
///
/// **Rollout:** active since the V2 release (started from `SensorAppApp`); the 90-day gate delays
/// the actual conversion until the account's pre-V2 devices have stopped recording.
/// **Decommission with the iOS 28 release:** delete this file, its call site and
/// `LegacyRecordingConverterTests`, together with the legacy fallback (the `// MARK: - Legacy rows`
/// helpers in `Extension+SensorSession.swift`, the legacy branches of `load…Samples()` /
/// `…SampleTotal`, and the row deletes in `RecordingStore.deleteSession`; see CLAUDE.md,
/// "Known tech debt"). The `@available` deprecation below turns
/// every use into a compiler warning as soon as the deployment target is raised to iOS 28.
///
/// Each session is converted in its own transaction (load its rows, write the archives, delete the
/// rows, save), so an interrupted run never leaves a half-converted session and simply continues on
/// the next launch. Converted sessions have archives and are skipped, so the job is idempotent and
/// harmless if two devices of the same account run it at the same time; iCloud syncs the result to
/// the other devices.
///
/// **Gate:** a device that still runs a pre-V2 version can only read the per-sample rows. While the
/// account has an old-format session created within `activeLegacyWindow`, such a device is probably
/// still recording, so nothing is converted.
@available(
    iOS, deprecated: 28.0,
    message: "One-time V1 → V2 recording conversion: remove with the iOS 28 release, together with the legacy fallback"
)
public actor LegacyRecordingConverter {

    private let modelContainer: ModelContainer
    private let activeLegacyWindow: TimeInterval

    /// - Parameter activeLegacyWindow: How long the account must go without a new old-format
    ///   recording before converting. Defaults to 90 days.
    public init(modelContainer: ModelContainer, activeLegacyWindow: TimeInterval = 90 * 24 * 60 * 60) {
        self.modelContainer = modelContainer
        self.activeLegacyWindow = activeLegacyWindow
    }

    /// Converts all old-format sessions, unless the gate blocks it.
    /// - Parameter now: The current date; injectable for tests.
    /// - Returns: The number of converted sessions.
    @discardableResult
    public func run(now: Date = .now) async -> Int {
        let legacySessionIDs: [UUID]
        do {
            legacySessionIDs = try findLegacySessions(createdBefore: now.addingTimeInterval(-activeLegacyWindow))
        } catch {
            Logger.recording.error("Legacy conversion skipped: \(error)")
            return 0
        }

        var converted = 0
        for sessionID in legacySessionIDs {
            do {
                try await convertSession(id: sessionID)
                converted += 1
            } catch {
                // Leave this session as it is; the next run tries again.
                Logger.recording.error("Converting legacy session \(sessionID) failed: \(error)")
            }
        }
        if converted > 0 {
            Logger.recording.notice("Converted \(converted, privacy: .public) legacy recordings to sample archives")
        }
        return converted
    }

    /// IDs of the sessions that still have per-sample rows, or none if one of them was created after
    /// `cutoff` (a pre-V2 device is probably still in use).
    private func findLegacySessions(createdBefore cutoff: Date) throws -> [UUID] {
        let context = ModelContext(modelContainer)
        let unarchived = try context.fetch(
            FetchDescriptor<SensorSession>(
                predicate: #Predicate {
                    $0.motionSampleCount == 0 && $0.altitudeSampleCount == 0 && $0.locationSampleCount == 0
                }
            )
        )

        var legacy: [(id: UUID, createdAt: Date)] = []
        for session in unarchived where try hasRows(sessionID: session.id, in: context) {
            legacy.append((session.id, session.createdAt))
        }

        if let newest = legacy.map(\.createdAt).max(), newest > cutoff {
            Logger.recording.notice(
                "Legacy conversion postponed: an old-format recording was made \(newest.formatted(), privacy: .public)"
            )
            return []
        }
        return legacy.map(\.id)
    }

    private func hasRows(sessionID: UUID, in context: ModelContext) throws -> Bool {
        let motion = FetchDescriptor<MotionMeasurement>(predicate: #Predicate { $0.session?.id == sessionID })
        let altitude = FetchDescriptor<AltitudeMeasurement>(predicate: #Predicate { $0.session?.id == sessionID })
        let location = FetchDescriptor<LocationMeasurement>(predicate: #Predicate { $0.session?.id == sessionID })
        return try context.fetchCount(motion) > 0
            || context.fetchCount(altitude) > 0
            || context.fetchCount(location) > 0
    }

    /// Converts one session in a single transaction. If anything throws, the context is discarded
    /// and the session keeps its rows.
    private func convertSession(id sessionID: UUID) async throws {
        let context = ModelContext(modelContainer)
        context.autosaveEnabled = false
        var descriptor = FetchDescriptor<SensorSession>(predicate: #Predicate { $0.id == sessionID })
        descriptor.fetchLimit = 1
        guard let session = try context.fetch(descriptor).first else { return }

        // Reads the legacy rows in recording order (the sample counts are still 0).
        let motion = try await session.loadMotionSamples()
        let altitude = try await session.loadAltitudeSamples()
        let location = try await session.loadLocationSamples()

        try session.setSamples(motion: motion, altitude: altitude, location: location)
        try context.delete(model: MotionMeasurement.self, where: #Predicate { $0.session?.id == sessionID })
        try context.delete(model: AltitudeMeasurement.self, where: #Predicate { $0.session?.id == sessionID })
        try context.delete(model: LocationMeasurement.self, where: #Predicate { $0.session?.id == sessionID })
        try context.save()
    }
}
