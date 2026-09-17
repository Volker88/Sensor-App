//
//  NavigationRoute.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.09.26.
//

import SwiftUI

/// Unified navigation route so every tab's ``NavigationStack`` shares a single path element type.
///
/// Required because `.tabViewStyle(.sidebarAdaptable)` renders the `TabView` as a
/// `NavigationSplitView` with one shared detail column on iPad. Binding tabs to differently-typed
/// paths (`PositionStack` vs `MotionStack` vs `MagnetometerStack` vs `RecordingsStack`) makes
/// SwiftUI's `NavigationColumnState` compare one stack's element against another's when switching
/// tabs, which crashes with `AnyNavigationPath.Error.comparisonTypeMismatch`. Sharing one element
/// type lets that comparison resolve to "not equal" instead of trapping.
enum NavigationRoute: Hashable {
    case position(PositionStack)
    case motion(MotionStack)
    case magnetometer(MagnetometerStack)
    case recordings(RecordingsStack)

    /// The regular-layout tab this route is promoted to when it's the first entry in a stack, if any.
    var rootTab: RootTab? {
        switch self {
            case .position(let route):
                route.rootTab
            case .motion(let route):
                route.rootTab
            case .magnetometer, .recordings:
                nil
        }
    }
}

// MARK: - View Extension
extension NavigationRoute: View {
    var body: some View {
        switch self {
            case .position(let route):
                route
            case .motion(let route):
                route
            case .magnetometer(let route):
                route
            case .recordings(let route):
                route
        }
    }
}
