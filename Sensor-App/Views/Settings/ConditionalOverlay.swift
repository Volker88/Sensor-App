//
//  ConditionalOverlay.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 18.07.22.
//

import SwiftUI

struct ConditionalOverlay: ViewModifier {
    let visible: Bool

    func body(content: Content) -> some View {
        if visible {
            content
                .overlay(
                    Image(systemName: "checkmark")
                        .bold()
                        .padding(3)
                        .foregroundColor(.white), alignment: .bottomTrailing)
        } else {
            content
        }
    }
}

extension View {
    func conditionalOverlay(visible: Bool) -> some View {
        self.modifier(ConditionalOverlay(visible: visible))
    }
}
