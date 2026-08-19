//
//  AdBannerView.swift
//  Sensor-App
//

import KickstartExchange
import SwiftUI

/// Reusable Kickstart Exchange banner ad, using the preview key in Debug builds.
struct AdBannerView: View {

    // MARK: - Body
    var body: some View {
        ExchangeBannerAdView(apiKey: apiKey)
            .padding()
    }

    private var apiKey: String {
        #if DEBUG
            "preview"
        #else
            guard let value = Bundle.main.object(forInfoDictionaryKey: "KICKSTART_EXCHANGE_API_KEY") as? String else {
                return "preview"
            }
            return value
        #endif
    }
}

// MARK: - Preview
#Preview {
    AdBannerView()
}
