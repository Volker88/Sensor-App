//
//  ContainerConfiguration.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

// Read from Info.plist keys that expand from xcconfig build settings.
// "APP_GROUP_ID" stores "group.$(APP_GROUP_ID)$(APP_GROUP_ID_SUFFIX)" — fully resolved at build time
// via Debug/Release xcconfig (suffix is ".dev" for debug, empty for release).
// "CLOUDKIT_CONTAINER_ID" stores "$(CLOUDKIT_CONTAINER_ID)".
nonisolated enum ContainerConfiguration {
    static var appGroupID: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "APP_GROUP_ID") as? String else {
            fatalError("APP_GROUP_ID not found in Info.plist — check xcconfig configuration")
        }
        return value
    }

    static var cloudKitContainerID: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "CLOUDKIT_CONTAINER_ID") as? String else {
            fatalError("CLOUDKIT_CONTAINER_ID not found in Info.plist — check xcconfig configuration")
        }
        return value
    }
}
