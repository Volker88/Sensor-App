//
//  DisclosureGroupModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct Definition
struct DisclosureGroupModifier: ViewModifier {
    
    // MARK: - Define Constants / Variables
    var accessibility: String
    
    
    // MARK: - Body
    func body(content: Content) -> some View {
        
        // MARK: - Return View
        return content
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
    func disclosureGroupModifier(accessibility: String) -> some View {
        self.modifier(DisclosureGroupModifier(accessibility: accessibility))
    }
}
