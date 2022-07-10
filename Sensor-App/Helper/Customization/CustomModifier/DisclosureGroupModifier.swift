//
//  DisclosureGroupModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.08.20.
//

import SwiftUI

struct DisclosureGroupModifier: ViewModifier {
    var accessibility: String

    func body(content: Content) -> some View {
        content
            .accessibility(identifier: accessibility)
            .accessibility(label: Text("Toggle Graph", comment: "GraphButtonModifier - Toggle Graph"))
    }
}

extension View {
    /// GraphButtonModifier
    ///
    /// Applies customization to GraphButtons
    ///
    /// - Parameter accessibility: String for UI Test
    /// - Returns: View
    func disclosureGroupModifier(accessibility: String) -> some View {
        modifier(DisclosureGroupModifier(accessibility: accessibility))
    }
}
