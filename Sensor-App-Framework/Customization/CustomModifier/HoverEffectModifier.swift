//
//  HoverEffectModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.05.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import SwiftUI


// MARK: - Struct Definition
struct HoverEffectModifier: ViewModifier {
    
    // MARK: - Body
    func body(content: Content) -> some View {
        
        // MARK: - Return View
        if #available(iOS 13.4, *) {
            return AnyView(content
                .hoverEffect(.automatic))
        } else {
            return AnyView(content)
        }
    }
}


// MARK: - Extension View
extension View {
    
    // MARK: - Define Function
    ///
    /// Hover Effect
    ///
    /// Apply HoverEffect on Buttons on iPadOS.
    /// Only working with Mouse / Trackpad
    ///
    /// - Precondition: iPadOS 13.4
    ///
    /// - Returns: View
    ///
    func hoverEffectModifier() -> some View {
        self.modifier(HoverEffectModifier()) // Apply Custom Modifier
    }
}

