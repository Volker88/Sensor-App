//
//  CustomNavigationViewStyle.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.08.20.
//


// MARK: - Import
import SwiftUI

// MARK: - Struct Definition
struct CustomNavigationViewStyle: ViewModifier {
    
    // MARK: - Body
    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            content
                .navigationViewStyle(StackNavigationViewStyle())
        } else {
            content
        }
        #else
        content
        #endif
    }
}


// MARK: - Extension View
extension View {
    // MARK: - Define Function
    ///
    /// NavigationBarStyle Modifier
    ///
    /// On iOS a StackNavigationViewStyle will be applied whereas on iPadOS no stlye will be applied
    ///
    /// - Returns: View
    ///
    func customNavigationViewStyle() -> some View {
        modifier(CustomNavigationViewStyle()) // Apply Custom Modifier
    }
}
