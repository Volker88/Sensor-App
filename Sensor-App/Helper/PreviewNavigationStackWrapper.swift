//
//  PreviewNavigationStackWrapper.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 25.09.2024.
//

import SwiftUI

/// Wraps as view into a ``NavigationStack``
struct PreviewNavigationStackWrapper: ViewModifier {
    func body(content: Content) -> some View {
        NavigationStack {
            content
                .environment(SettingsManager())
                .environment(CalculationManager())
                .environment(MotionManager())
                .environment(LocationManager())
        }
    }
}

extension View {
    /// Wraps as view into a ``NavigationStack``
    ///
    /// - Returns: ``View``
    func previewNavigationStackWrapper() -> some View {
        modifier(PreviewNavigationStackWrapper())
    }
}
