//
//  MapKitView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 12.07.22.
//

import SwiftUI
import MapKit

struct MapKitView: UIViewRepresentable {
    let mapView = MKMapView()

    let settings = SettingsAPI()
    var fullScreen: Bool

    init(fullScreen: Bool = false) {
        self.fullScreen = fullScreen
    }

    func makeUIView(context: Context) -> MKMapView {
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
        view.isPitchEnabled = mapKitSettings.isPitchEnabled
        view.isScrollEnabled = mapKitSettings.isScrollEnabled
        view.showsScale = mapKitSettings.showsScale
        view.userTrackingMode = .follow

        // Map Appearance
        switch mapKitSettings.mapType {
            case .standard: view.mapType = MKMapType.standard
            case .satellite: view.mapType = MKMapType.satellite
            case .hybrid: view.mapType = MKMapType.hybrid
            case .satelliteFlyover: view.mapType = MKMapType.satelliteFlyover
            case .hybridFlyover: view.mapType = MKMapType.hybridFlyover
            case .mutedStandard: view.mapType = MKMapType.mutedStandard
        }

        // User Coordinates
        let coordinate = CLLocationCoordinate2D(
            latitude: view.userLocation.coordinate.latitude,
            longitude: view.userLocation.coordinate.longitude
        )

        // Zoom Factor
        let region = MKCoordinateRegion(
            center: coordinate, latitudinalMeters: mapKitSettings.zoom,
            longitudinalMeters: mapKitSettings.zoom
        )
        view.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension MapKitView {
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapKitView

        init(_ parent: MapKitView) {
            self.parent = parent
        }
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {

        }
    }
}

struct MapKitView_Previews: PreviewProvider {
    static var previews: some View {
        MapKitView()
            .previewLayout(.sizeThatFits)
    }
}
