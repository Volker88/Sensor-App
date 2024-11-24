//
//  NavigationStackWrapper.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11/24/24.
//

import SwiftUI

/// Wraps as view into a ``NavigationStack``
struct NavigationStackWrapper: ViewModifier {
    func body(content: Content) -> some View {
        NavigationStack {
            content
        }
    }
}

extension View {
    /// Wraps as view into a ``NavigationStack``
    ///
    /// - Returns: ``View``
    func navigationStackWrapper() -> some View {
        modifier(NavigationStackWrapper())
    }
}
