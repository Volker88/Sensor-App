//
//  Extension_Map.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 08.08.20.
//

import MapKit
import Sensor_App_Framework
import SwiftUI

extension Map {
    /// MapStyle
    /// - Returns: View
    func mapStyle() -> some View {
        let settingsAPI = SettingsManager()
        let mapKitSettings = settingsAPI.fetchMapKitSettings()
        let map = MKMapView.appearance()

        // Map Appearance
        switch mapKitSettings.mapType {
            case .standard: map.mapType = MKMapType.standard
            case .satellite: map.mapType = MKMapType.satellite
            case .hybrid: map.mapType = MKMapType.hybrid
            case .satelliteFlyover: map.mapType = MKMapType.satelliteFlyover
            case .hybridFlyover: map.mapType = MKMapType.hybridFlyover
            case .mutedStandard: map.mapType = MKMapType.mutedStandard
        }

        map.showsCompass = mapKitSettings.showsCompass
        map.showsBuildings = mapKitSettings.showsBuildings
        map.showsTraffic = mapKitSettings.showsTraffic
        map.showsScale = mapKitSettings.showsScale

        return self
    }
}
