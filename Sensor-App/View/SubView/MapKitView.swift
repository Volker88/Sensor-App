//
//  MapKitView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI
import MapKit


// MARK: - Struct
struct MapKitView: UIViewRepresentable {
    
    // MARK: - Define Constants / Variables
    private var latitude: Double
    private var longitude: Double
    
    // MARK: - Initialize Coordinates
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    // MARK: - MapkitView
    func makeUIView(context: Context) -> MKMapView {
        return MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
        // Settings
        view.showsUserLocation = true
        view.showsCompass = true
        view.showsBuildings = true
        view.showsTraffic = true
        view.isRotateEnabled = true
        view.isPitchEnabled = true
        
        // Map Appearance
        view.mapType = MKMapType.standard
        //view.mapType = MKMapType.satellite
        //view.mapType = MKMapType.hybrid
        //view.mapType = MKMapType.satelliteFlyover
        //view.mapType = MKMapType.hybridFlyover
        //view.mapType = MKMapType.mutedStandard
        
        // User Coordinates
        let coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)

        // Zoom Factor
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
    }
}


// MARK: - Preview
struct MapKitView_Previews: PreviewProvider {
    static var previews: some View {
        MapKitView(latitude: 37.3323314100, longitude: -122.0312186000)
            .previewLayout(.sizeThatFits)
    }
}
