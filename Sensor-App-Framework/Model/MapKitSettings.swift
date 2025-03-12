//
//  MapKitSettings.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 28.03.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import Foundation

public enum MapType: String, Codable, CaseIterable {
    case standard = "Standard"
    case satellite = "Satellite"
    case hybrid = "Hybrid"
    case satelliteFlyover = "Satellite Flyover"
    case hybridFlyover = "Hybrid Flyover"
    case mutedStandard = "Muted Standard"
}

public struct MapKitSettings: Codable {
    public var showsCompass: Bool
    public var showsScale: Bool
    public var showsBuildings: Bool
    public var showsTraffic: Bool
    public var isRotateEnabled: Bool
    public var isPitchEnabled: Bool
    public var isScrollEnabled: Bool
    public var mapType: MapType
    public var zoom: Double
}
