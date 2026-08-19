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
    @Environment(\.showNotification) private var showNotification
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(LocationManager.self) private var locationManager
    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        LocationView()
            .safeAreaInset(edge: .bottom) {
                Color.clear
                    .frame(height: 175)
            }
            .overlay(alignment: .bottom) {
                CustomControlsView()
            }
            .safeAreaInset(edge: .bottom) {
                if horizontalSizeClass != .compact {
                    AdBannerView()
                }
            }
            .navigationTitle(RootTab.location.localizedString)
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
