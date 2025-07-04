//
//  LocationScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 24.08.20.
//

import Sensor_App_Framework
import StoreKit
import SwiftUI

struct LocationScreen: View {

    @Environment(\.requestReview) private var requestReview

    // MARK: - Body
    var body: some View {
        LocationView()
            .toolbar {
                CustomToolbar()
            }
            .navigationTitle(Text("Location", comment: "NavigationBar Title - Location view screen"))
            .onDisappear {
                #if RELEASE
                    requestReview()
                #endif
            }
    }
}

// MARK: - Preview
#Preview("LocationScreen - English", traits: .navEmbedded) {
    LocationScreen()
}

#Preview("LocationScreen - German", traits: .navEmbedded) {
    LocationScreen()
        .previewLocalization(.german)
}
