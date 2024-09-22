//
//  MapView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.07.22.
//

import SwiftUI

struct MapView: View {

    // MARK: - Body
    var body: some View {
        MapKitView()
            .navigationTitle(NSLocalizedString("Map", comment: "NavigationBar Title - Map"))
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
    MapView()
        .previewNavigationStackWrapper()
}
