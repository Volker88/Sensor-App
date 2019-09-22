//
//  CoreLocationViewModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 06.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import Combine


// MARK: - Class Definition
class CoreLocationViewModel: ObservableObject {
    
    // MARK: - Define Constants / Variables
    @Published var coreLocationArray = [LocationModel]()
    
    
    // MARK: - Methods
    func locationUpdateStart() {
        CoreLocationAPI.shared.startUpdatingGPS()
        CoreLocationAPI.shared.locationCompletionHandler = { GPS in
               
            // Append LocationModel to coreLocationArray
            self.coreLocationArray.append(LocationModel(
                counter: self.coreLocationArray.count + 1, 
                longitude: GPS.longitude,
                latitude: GPS.latitude,
                altitude: GPS.altitude,
                speed: GPS.speed,
                course: GPS.course,
                horizontalAccuracy: GPS.horizontalAccuracy,
                verticalAccuracy: GPS.verticalAccuracy,
                timestamp: GPS.timestamp,
                GPSAccuracy: GPS.GPSAccuracy
            ))
        }
    }
}

