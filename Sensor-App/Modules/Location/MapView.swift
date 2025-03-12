//
//  MapView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.07.22.
//

import Sensor_App_Framework
import SwiftUI

struct MapView: View {

    // MARK: - Body
    var body: some View {
        MapKitView()
            .navigationTitle(Text("Map", comment: "NavigationBar Title - Map to show current location"))
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview("MapView - English", traits: .navEmbedded) {
    MapView()
}

#Preview("MapView - German", traits: .navEmbedded) {
    MapView()
        .previewLocalization(.german)
}
