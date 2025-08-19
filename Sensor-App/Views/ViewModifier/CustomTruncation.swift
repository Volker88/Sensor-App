//
//  CustomTruncation.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.08.25.
//

import SwiftUI

// MARK: - Reusable Text Style for Card labels
struct CustomTruncation: ViewModifier {

    let lineLimit: Int?
    let minimumScaleFactor: CGFloat
    let fixedHorizontalSize: Bool
    let fixedVerticalSize: Bool

    func body(content: Content) -> some View {
        content
            .lineLimit(lineLimit)
            .minimumScaleFactor(minimumScaleFactor)
            .fixedSize(horizontal: fixedHorizontalSize, vertical: fixedVerticalSize)
    }
}

// MARK: - Extension
extension View {
    func customTruncation(
        lineLimit: Int? = nil,
        minimumScaleFactor: CGFloat = 0.5,
        fixedHorizontalSize: Bool = false,
        fixedVerticalSize: Bool = false
    ) -> some View {
        self.modifier(
            CustomTruncation(
                lineLimit: lineLimit,
                minimumScaleFactor: minimumScaleFactor,
                fixedHorizontalSize: fixedHorizontalSize,
                fixedVerticalSize: fixedVerticalSize
            )
        )
    }
}
