//
//  NavigationBarItemModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.05.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct NavigationBarItemModifier: ViewModifier {
    var accessibility: String

    func body(content: Content) -> some View {
        content
            .padding(10)
            .hoverEffect()
            .accessibility(identifier: accessibility)
    }
}

extension View {
    /// NavigationBarItem
    ///
    /// Applies customization to NavigationBarItems
    ///
    /// - Precondition: iPadOS 13.4 for HoverEffect
    /// - Parameter accessibility: String for UI Test
    /// - Returns: View
    func navigationBarItemModifier(accessibility: String) -> some View {
        modifier(NavigationBarItemModifier(accessibility: accessibility))
    }
}
