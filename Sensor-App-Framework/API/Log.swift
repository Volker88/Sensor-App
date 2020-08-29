//
//  Log.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 29.08.20.
//


// MARK: - Import
import Foundation
import os


// MARK: - Struct / Class Definition
class Log {
    
    // MARK: - Enum
    enum LogCategory: String {
        case scenePhase = "ScenePhase"
        case appUpdates = "AppUpdates"
        case coreLocation = "CoreLocation"
        case coreMotion = "CoreMotion"
        case exportFile = "ExportFile"
        case userDefaults = "UserDefaults"
    }
    
    
    // MARK: - Define Constants / Variables
    static let shared = Log()
    private let bundleID = Bundle.main.bundleIdentifier
    
    
    // MARK: - Initializer
    private init() {
    }
    
    
    // MARK: - Methods
    ///
    /// Write to Log
    ///
    /// - Parameters:
    ///   - category: Log Category
    ///   - logType: Log Type
    ///   - message: Log Message
    ///
    func add(_ category: LogCategory, _ logType: OSLogType, _ message: String)  {
        let logger = Logger(subsystem: "\(bundleID!)", category: "\(category.rawValue)")
        switch logType {
        case .debug:
            logger.log(level: .debug, "Debug: \(message)")
        case .default:
            logger.log(level: .default, "Default: \(message)")
        case .error:
            logger.log(level: .error, "Error: \(message)")
        case .fault:
            logger.log(level: .fault, "Fault: \(message)")
        case .info:
            logger.log(level: .info, "Info: \(message)")
        default:
            logger.log(level: .error, "No log type specified: \(message)")
        }
    }
    
    
    ///
    /// Print
    ///
    /// If DEBUGGING is set to 1, print Statements will be shown in Console
    ///
    /// - Note: Debugging can be set in User-Defined Build Settings
    ///
    /// - Parameter value: Any
    ///
    func print(_ value: Any) {
        if Bundle.main.infoDictionary?["Debugging"] as! String == "1" {
            Swift.print(value)
        }
    }
}
