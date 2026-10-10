//
//  EnvironmentValues+UsesCompactLayout.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 10.10.26.
//

import SwiftUI

extension EnvironmentValues {

    /// Whether `ContentView` is showing the grouped compact layout (umbrella tabs with pushed
    /// screens) rather than the flat sidebar layout.
    ///
    /// This is not derivable from the size classes alone, because phones always use the compact
    /// layout, including a Duo whose unfolded display reports regular size classes. Views that
    /// depend on which layout hosts them read this instead of re-deriving it.
    @Entry var usesCompactLayout = true
}
