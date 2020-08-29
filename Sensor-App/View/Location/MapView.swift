//
//  MapView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI
import MapKit


// MARK: - Struct / Class Definition
struct MapView: View {
    
    // MARK: - Initialize Classes
    let settingsAPI = SettingsAPI()
    
    
    // MARK: - Environment Object
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var locationVM: CoreLocationViewModel
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    
    // MARK: - Define Constants / Variables
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
    
    
    // MARK: - Initializer
    
    // MARK: - Methods
    
    // MARK: - Body
    var body: some View {
        
        // MARK: - Return View
        return Map(
            coordinateRegion: .constant(region),
            interactionModes: MapInteractionModes.all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode
        )
        .mapStyle()
    }
}


// MARK: - Preview
struct MapKitView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            MapView(locationVM: CoreLocationViewModel())
                .colorScheme(scheme)
                .previewLayout(.fixed(width: 400, height: 400))
        }
        
    }
}
