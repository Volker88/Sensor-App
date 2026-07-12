//
//  SwiftDataContainer.swift
//  Sensor-App-Framework
//

import OSLog
import SwiftData

// Intentionally `nonisolated`: this is a builder/holder for a `Sendable` `ModelContainer?` and does
// no main-actor work. Read-only consumers (widget `EntityQuery`/timeline providers) construct it from
// nonisolated contexts, so it must not be forced onto the main actor by default isolation.
public nonisolated class SwiftDataContainer {
    /// The backing store. This is intentionally optional: read-only consumers (widgets/extensions)
    /// must never crash the host process when the store cannot be opened. When this is `nil`,
    /// consumers degrade to placeholder content instead of trapping. The main app treats a `nil`
    /// container as genuinely fatal and unwraps it explicitly at its own call site.
    public let modelContainer: ModelContainer?

    public init(inMemory: Bool = false, allowsSave: Bool = true) {  // swiftlint:disable:this function_body_length
        // Try to build the requested container. If it fails (common in extensions),
        // log and fall back to an in-memory, read-only container to avoid crashing.
        do {
            let schema = Schema(versionedSchema: LatestModelSchema.self)
            if allowsSave {
                // Only writable consumers (the main app) own schema migration. Running the
                // migration plan performs file I/O on the persistent store to upgrade the schema.
                // CloudKit mirroring stays enabled (.automatic) so the app keeps syncing.
                let configuration = ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: inMemory,
                    allowsSave: true,
                    groupContainer: .identifier(ContainerConfiguration.appGroupID),
                    cloudKitDatabase: .private(ContainerConfiguration.cloudKitContainerID)
                )

                modelContainer = try ModelContainer(
                    for: schema,
                    migrationPlan: DatabaseMigrationPlan.self,
                    configurations: configuration
                )

            } else {
                // Read-only consumers (widgets/extensions) must not drive migration. Attempting it
                // performs file I/O that can fail in the extension sandbox — e.g. when a widget
                // refreshes in the background while the device is locked and the store file is
                // protected (seen across iOS, iPadOS and visionOS; crash signature
                // B8qLDzeXPQZm0380CatZM-). Open the already-migrated store as-is.
                //
                // CloudKit MUST be disabled here (cloudKitDatabase: .none). SwiftData's CloudKit
                // mirroring requires a writable store, so leaving it at .automatic makes the
                // read-only open throw — which crashed the extension before the fallback below
                // existed, and now silently degrades to an empty in-memory store. That empty store
                // is why the widget's configuration picker (suggestedEntities) shows no items and
                // dismisses immediately. The shared app-group container (groupContainer: .automatic)
                // still points at the same on-disk store the main app populated and synced, so
                // disabling CloudKit here only skips mirroring — it does not lose access to data.
                let configuration = ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: inMemory,
                    allowsSave: false,
                    groupContainer: .identifier(ContainerConfiguration.appGroupID),
                    cloudKitDatabase: .none
                )

                modelContainer = try ModelContainer(
                    for: schema,
                    configurations: configuration
                )

            }
        } catch {
            Logger.swiftData.error(
                "Failed to load model container (inMemory=\(inMemory), allowsSave=\(allowsSave)): \(String(describing: error), privacy: .public)"
            )
            // Fallback: in-memory, read-only container to keep extensions/widgets alive.
            // This is the primary crash-stopper for signature B8qLDzeXPQZm0380CatZM-: if the
            // on-disk store cannot be opened at all (e.g. a widget refreshing while the device is
            // locked, on iOS/iPadOS/visionOS), we surface placeholder content instead of trapping.
            // No migration plan here — in-memory stores are always freshly created.
            do {
                let schema = Schema(versionedSchema: LatestModelSchema.self)
                // CloudKit must be off here too: an in-memory store can't mirror to CloudKit, and
                // leaving it at .automatic risks throwing in this last-resort path and degrading to a
                // nil container below.
                let configuration = ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: true,
                    allowsSave: false,
                    groupContainer: .identifier(ContainerConfiguration.appGroupID),
                    cloudKitDatabase: .none
                )

                modelContainer = try ModelContainer(
                    for: schema,
                    configurations: configuration
                )

                Logger.swiftData.info("Fell back to in-memory SwiftData container for safety.")
            } catch {
                // Last resort: never trap. Even an in-memory store can throw inside an extension
                // sandbox on shipping OSes (observed on iOS 26.5, crash signature
                // "SwiftDataContainer.init(inMemory:allowsSave:)"). Returning a nil container lets
                // widgets/extensions render placeholder content instead of taking down the whole
                // extension. The main app unwraps this explicitly and fails loudly at its own site.
                Logger.swiftData.fault(
                    "Failed to create even an in-memory SwiftData container: \(String(describing: error), privacy: .public)"
                )
                self.modelContainer = nil
            }
        }
    }
}
