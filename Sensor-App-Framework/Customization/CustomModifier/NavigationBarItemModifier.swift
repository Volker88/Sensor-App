//
//  NavigationBarItemModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.05.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct Definition
struct NavigationBarItemModifier: ViewModifier {
    
    // MARK: - Define Constants / Variables
    var accessibility: String
    
    
    // MARK: - Body
    func body(content: Content) -> some View {
        
        // MARK: - Return View
        return content
            .padding(10)
            .hoverEffect()
            .accessibility(identifier: accessibility)
    }
}


// MARK: - Extension View
extension View {
    
    // MARK: - Define Function
    ///
    /// NavigationBarItem
    ///
    /// Applies customization to NavigationBarItems
    ///
    /// - Precondition: iPadOS 13.4 for HoverEffect
    ///
    /// - Parameter accessibility: String for UI Test
    ///
    /// - Returns: View
    ///
    func navigationBarItemModifier(accessibility: String) -> some View {
        self.modifier(NavigationBarItemModifier(accessibility: accessibility))
    }
}



