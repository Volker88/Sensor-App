//
//  ListViewModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.05.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct Definition
struct ListViewModifier: ViewModifier {
    
    // MARK: - Define Constants / Variables
    let width: CGFloat
    
    
    // MARK: - Body
    func body(content: Content) -> some View {
        
        // MARK: - Return View
        return AnyView(content
            .id(UUID())
            .frame(width: width)
            .cornerRadius(10)
            .opacity(0.3))
    }
}


// MARK: - Extension View
extension View {
    
    // MARK: - Define Function
    ///
    /// ListViewModifier
    ///
    /// Apply to format Lists
    ///
    /// - Parameter width: with of List
    /// - Returns: View
    ///
    func listViewModifier(width: CGFloat) -> some View {
        self.modifier(ListViewModifier(width: width)) // Apply Custom Modifier
    }
}
