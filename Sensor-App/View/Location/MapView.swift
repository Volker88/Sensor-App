//
//  MapView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: View {
    let settingsAPI = SettingsAPI()

    @ObservedObject var locationVM: CoreLocationViewModel
    @State private var userTrackingMode: MapUserTrackingMode = .follow

    let interaction = MapInteractionModes()
    var region: MKCoordinateRegion {
        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: locationVM.coreLocationArray.last?.latitude ?? 40.7588996887207,
                                   longitude: locationVM.coreLocationArray.last?.longitude ?? -73.98505401611328
            )
        }
        return MKCoordinateRegion(center:
                                    coordinate,
                                  latitudinalMeters: settingsAPI.fetchMapKitSettings().zoom,
                                  longitudinalMeters: settingsAPI.fetchMapKitSettings().zoom
        )
    }

    var body: some View {
        Map(
            coordinateRegion: .constant(region),
            interactionModes: MapInteractionModes.all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode
        )
        .mapStyle()
    }
}

struct MapKitView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(locationVM: CoreLocationViewModel())
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
