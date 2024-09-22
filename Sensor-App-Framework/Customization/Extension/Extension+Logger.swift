//
//  Extension+Logger.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 29.08.20.
//

import Foundation
import OSLog

extension Logger {
    /// Application bundle identifier
    private static let subsystem = Bundle.main.bundleIdentifier! // swiftlint:disable:this force_unwrapping

    /// Log ``scenePhase`` events
    static let scenePhase = Logger(subsystem: subsystem, category: "scenePhase")

    /// Log ``viewCycle`` events
    static let viewCycle = Logger(subsystem: subsystem, category: "viewCycle")

    /// Log ``AppUpdates`` events
    static let appUpdate = Logger(subsystem: subsystem, category: "appUpdate")

    static let coreLocation = Logger(subsystem: subsystem, category: "coreLocation")

    static let coreMotion = Logger(subsystem: subsystem, category: "coreMotion")

    static let exportFile = Logger(subsystem: subsystem, category: "exportFile")

    static let userDefaults = Logger(subsystem: subsystem, category: "userDefaults")
}
