//
//  GraphButtonModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.05.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct Definition
struct GraphButtonModifier: ViewModifier {
    
    // MARK: - Define Constants / Variables
    var accessibility: String
    
    
    // MARK: - Body
    func body(content: Content) -> some View {
        
        // MARK: - Return View
        return content
            .padding(5)
            .hoverEffect()
            .foregroundColor(.white)
            .offset(x: -10)
            .accessibility(identifier: accessibility)
            .accessibility(label: Text("Toggle Graph", comment: "GraphButtonModifier - Toggle Graph"))
    }
}


// MARK: - Extension View
extension View {
    
    // MARK: - Define Function
    ///
    /// GraphButtonModifier
    ///
    /// Applies customization to GraphButtons
    ///
    /// - Parameter accessibility: String for UI Test
    ///
    /// - Returns: View
    ///
    func graphButtonModifier(accessibility: String) -> some View {
        modifier(GraphButtonModifier(accessibility: accessibility))
    }
}
