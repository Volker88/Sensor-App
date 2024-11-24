//
//  PreviewLocalizationModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11/24/24.
//

import SwiftUI

/// Wraps as view into a ``PreviewLocalizationModifier``
struct PreviewLocalizationModifier: ViewModifier {

    let locale: String

    func body(content: Content) -> some View {
        content
            .environment(\.locale, .init(identifier: locale))
    }
}

extension View {
    /// Wraps as view into a ``PreviewLocalizationModifier``
    ///
    /// - Returns: ``View``
    func previewLocalization(_ language: SupportedLanguage) -> some View {
        modifier(PreviewLocalizationModifier(locale: language.rawValue))
    }

    /// Wraps as view into a ``PreviewLocalizationModifier``
    ///
    /// - Returns: ``View``
    func previewLocalization(locale: String) -> some View {
        modifier(PreviewLocalizationModifier(locale: locale))
    }
}
