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
    @Binding var region: MKCoordinateRegion
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    
    // MARK: - Define Constants / Variables
    let interaction = MapInteractionModes()
    
    
    // MARK: - Initializer
    
    // MARK: - Methods
    
    // MARK: - Body
    var body: some View {
  
        // MARK: - Return View
        return Map(
            coordinateRegion: $region,
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
            MapView(region: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3323314100, longitude: -122.0312186000), latitudinalMeters: 10000, longitudinalMeters: 10000)))
                .colorScheme(scheme)
                .previewLayout(.fixed(width: 400, height: 400))
        }
        
    }
}


// MARK: - Not Used
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
    
    
    // MARK: - MapKitView
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


