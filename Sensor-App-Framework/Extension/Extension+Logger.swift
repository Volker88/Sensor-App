//
//  Extension+Logger.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 29.08.20.
//

import Foundation
import OSLog

nonisolated extension Logger {
    /// Application bundle identifier
    private static let subsystem = Bundle.main.bundleIdentifier!  // swiftlint:disable:this force_unwrapping

    /// Log App Icon Events
    public static let appIcon = Logger(subsystem: subsystem, category: "appIcon")

    /// Log ``scenePhase`` events
    public static let scenePhase = Logger(subsystem: subsystem, category: "scenePhase")

    /// Log ``viewCycle`` events
    public static let viewCycle = Logger(subsystem: subsystem, category: "viewCycle")

    /// Log ``AppUpdates`` events
    public static let appUpdate = Logger(subsystem: subsystem, category: "appUpdate")

    /// Log ``coreLocation`` events
    public static let coreLocation = Logger(subsystem: subsystem, category: "coreLocation")

    /// Log ``coreMotion`` events
    public static let coreMotion = Logger(subsystem: subsystem, category: "coreMotion")

    /// Log ``ExportManager`` events
    public static let exportFile = Logger(subsystem: subsystem, category: "exportFile")

    /// Log ``userDefaults`` events
    public static let userDefaults = Logger(subsystem: subsystem, category: "userDefaults")

    /// Log ``RecordingManager`` events
    public static let recording = Logger(subsystem: subsystem, category: "recording")

    /// Log ``SwiftData`` events
    public static let swiftData = Logger(subsystem: subsystem, category: "swiftData")

    /// Log ``CloudKit`` events
    public static let cloudKit = Logger(subsystem: subsystem, category: "cloudKit")
}
