//
//  InitializeCloudKitSchema.swift
//  Sensor-App-Framework
//
//  Run once in DEBUG before SwiftDataContainer.make() to push the schema to CloudKit.
//  Set initialize to false after the first successful run.
//

import CoreData
import Foundation
import SwiftData

public enum InitializeCloudKitSchema {

    public static func initialize(_ initialize: Bool) {
        guard initialize else { return }
        #if DEBUG
            do {
                try autoreleasepool {
                    let storeURL = ModelConfiguration(
                        isStoredInMemoryOnly: false,
                        groupContainer: .identifier(ContainerConfiguration.appGroupID)
                    ).url

                    let desc = NSPersistentStoreDescription(url: storeURL)
                    let opts = NSPersistentCloudKitContainerOptions(
                        containerIdentifier: ContainerConfiguration.cloudKitContainerID)
                    desc.cloudKitContainerOptions = opts
                    desc.shouldAddStoreAsynchronously = false

                    if let mom = NSManagedObjectModel.makeManagedObjectModel(for: [
                        SensorSession.self,
                        MotionMeasurement.self,
                        AltitudeMeasurement.self,
                        LocationMeasurement.self
                    ]) {
                        let container = NSPersistentCloudKitContainer(name: "Sensor-App", managedObjectModel: mom)
                        container.persistentStoreDescriptions = [desc]
                        container.loadPersistentStores { _, err in
                            if let err { fatalError(err.localizedDescription) }
                        }
                        try container.initializeCloudKitSchema()
                        if let store = container.persistentStoreCoordinator.persistentStores.first {
                            try container.persistentStoreCoordinator.remove(store)
                        }
                    }
                }
            } catch {
                fatalError("Failed to initialize CloudKit schema: \(error)")
            }
        #endif
    }
}
