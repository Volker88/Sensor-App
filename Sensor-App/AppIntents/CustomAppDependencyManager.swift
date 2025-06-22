//
//  CustomAppDependencyManager.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 22.06.25.
//

import Foundation

/// Overwrites AppDependencyManager in a nonisolated context. If this doesn't work well, migrate to URL Schema
nonisolated final class CustomAppDependencyManager {
    nonisolated(unsafe) static let shared = CustomAppDependencyManager()

    private var dependencies: [String: Any] = [:]

    func add<T>(key: String, dependency: T) {
        dependencies[key] = dependency
    }

    func get<T>(key: String) -> T? {
        dependencies[key] as? T
    }
}
