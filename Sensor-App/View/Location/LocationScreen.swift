//
//  LocationScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 24.08.20.
//

import SwiftUI
import StoreKit

struct LocationScreen: View {

    @Environment(\.requestReview) private var requestReview

    // MARK: - Body
    var body: some View {
        LocationView()
            .toolbar {
                CustomToolbar()
            }
            .navigationTitle(NSLocalizedString("Location", comment: "NavigationBar Title - Location"))
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                    case .location:
                        MapView()
                    default:
                        MapView()
                }
            })
            .onDisappear {
#if RELEASE
                requestReview()
#endif
            }
    }
}

// MARK: - Preview
#Preview {
    LocationScreen()
        .previewNavigationStackWrapper()
}
