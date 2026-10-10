//
//  NavigationLayout.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 10.10.26.
//

import SwiftUI

/// Decides which tab layout `ContentView` shows.
enum NavigationLayout {

    /// Whether to show the grouped compact layout instead of the flat sidebar layout.
    ///
    /// The flat layout needs room in both directions and is reserved for iPad. Phones always keep
    /// the compact layout: a Plus/Max in landscape or an unfolded iPhone Duo can report regular
    /// size classes, but the flat layout's tabs would overflow into a More menu there.
    ///
    /// - Parameters:
    ///   - horizontalSizeClass: The horizontal size class of the view hosting the tabs.
    ///   - verticalSizeClass: The vertical size class of the view hosting the tabs.
    ///   - isPhone: Whether the device idiom is iPhone. This is a product decision (sidebar on
    ///     iPad only) rather than a question of available space, and SwiftUI has no idiom
    ///     environment value, so the caller reads it from the device.
    static func usesCompactLayout(
        horizontalSizeClass: UserInterfaceSizeClass?,
        verticalSizeClass: UserInterfaceSizeClass?,
        isPhone: Bool
    ) -> Bool {
        horizontalSizeClass != .regular || verticalSizeClass == .compact || isPhone
    }
}
