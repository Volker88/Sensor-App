//
//  CardView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.06.25.
//

import SwiftUI

struct CardView<Content: View>: View {

    @ViewBuilder let content: () -> Content

    // MARK: - Body
    var body: some View {
        VStack(alignment: .center) {
            content()
                .multilineTextAlignment(.center)
                .font(.title2)
                .bold()
        }
        .frame(width: 150, height: 150)
        .glassEffect()
    }
}

// MARK: - Preview
#Preview("CardView - English", traits: .navEmbedded) {
    CardView {
        Text("Acceleration")
    }
}

#Preview("CardView - German", traits: .navEmbedded) {
    CardView {
        Text("Acceleration")
    }
    .previewLocalization(.german)
}
