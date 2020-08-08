//
//  ToolBarButtonModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.05.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct Definition
struct ToolBarButtonModifier: ViewModifier {
    
    // MARK: - Define Constants / Variables
    var accessibility: String
    
    
    // MARK: - Body
    func body(content: Content) -> some View {
        
        // MARK: - Return View
        return content
            .font(.largeTitle)
            .padding(10)
            .hoverEffectModifier()
            .accessibility(identifier: accessibility)
    }
}


// MARK: - Extension View
extension View {
    
    // MARK: - Define Function
    ///
    /// ToolBarButtonItem
    ///
    /// Applies customization to NavigationBarItems
    ///
    /// - Precondition: iPadOS 13.4 for HoverEffect
    ///
    /// - Parameter accessibility: String for UI Test
    ///
    /// - Returns: View
    ///
    func toolBarButtonModifier(accessibility: String) -> some View {
        self.modifier(ToolBarButtonModifier(accessibility: accessibility))
    }
}
