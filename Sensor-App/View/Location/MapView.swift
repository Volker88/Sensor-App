//
//  MapView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.07.22.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        MapKitView()
            .navigationTitle(NSLocalizedString("Map", comment: "NavigationBar Title - Map"))
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
