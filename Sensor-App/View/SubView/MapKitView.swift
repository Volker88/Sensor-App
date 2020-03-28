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


struct MapKitView: UIViewRepresentable {
    
    // MARK: - Initialize Classes
    let settings = SettingsAPI()
    
    
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
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        // Settings
        let mapKitSettings = settings.fetchMapKitSettings()
        
        view.showsUserLocation = true
        view.showsCompass = mapKitSettings.showsCompass
        view.showsBuildings = mapKitSettings.showsBuildings
        view.showsTraffic = mapKitSettings.showsTraffic
        view.isRotateEnabled = mapKitSettings.isRotateEnabled
        view.isScrollEnabled = mapKitSettings.isScrollEnabled
        view.showsScale = mapKitSettings.showsScale
        
        
        // Map Appearance
        switch mapKitSettings.mapType {
            case .standard: view.mapType = MKMapType.standard
            case .satellite: view.mapType = MKMapType.satellite
            case .hybrid: view.mapType = MKMapType.hybrid
            case .satelliteFlyover: view.mapType = MKMapType.satelliteFlyover
            case .hybridFlyover: view.mapType = MKMapType.hybridFlyover
            case .mutedSandard: view.mapType = MKMapType.mutedStandard
        }
        
        // User Coordinates
        let coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        
        // Zoom Factor
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: mapKitSettings.zoom, longitudinalMeters: mapKitSettings.zoom)
        view.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapKitView
        
        init(_ parent: MapKitView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.latitude = mapView.centerCoordinate.latitude
            parent.longitude = mapView.centerCoordinate.longitude
        }
    }
    
}


// MARK: - Preview
struct MapKitView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            MapKitView(latitude: 37.3323314100, longitude: -122.0312186000)
                .colorScheme(scheme)
                .previewLayout(.fixed(width: 400, height: 400))
        }
        
    }
}
