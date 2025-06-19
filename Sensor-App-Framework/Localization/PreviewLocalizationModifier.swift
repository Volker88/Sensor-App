//
//  PreviewLocalizationModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11/24/24.
//

import SwiftUI

/// Wraps as view into a ``PreviewLocalizationModifier``
public struct PreviewLocalizationModifier: ViewModifier {

    public let locale: String

    public func body(content: Content) -> some View {
        content
            .environment(\.locale, .init(identifier: locale))
    }
}

extension View {
    /// Wraps as view into a ``PreviewLocalizationModifier``
    ///
    /// - Returns: ``View``
    public func previewLocalization(_ language: SupportedLanguage) -> some View {
        modifier(PreviewLocalizationModifier(locale: language.rawValue))
    }

    /// Wraps as view into a ``PreviewLocalizationModifier``
    ///
    /// - Returns: ``View``
    public func previewLocalization(locale: String) -> some View {
        modifier(PreviewLocalizationModifier(locale: locale))
    }
}
