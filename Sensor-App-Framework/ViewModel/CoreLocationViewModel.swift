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
        #if targetEnvironment(simulator)
        for _ in 1...100 {
            coreLocationArray.append(LocationModel(counter: 1, longitude: -120.03529395, latitude: 38.33458564, altitude: 10, speed: 23.24, course: 265.08, horizontalAccuracy: 5.0, verticalAccuracy: 5.0, timestamp: "17-11-2019 10:44:13.136", GPSAccuracy: -1.0))
            coreLocationArray.append(LocationModel(counter: 1, longitude: -123.03529395, latitude: 36.33458564, altitude: 10, speed: 25.24, course: 265.08, horizontalAccuracy: 5.0, verticalAccuracy: 5.0, timestamp: "17-11-2019 10:44:13.136", GPSAccuracy: -1.0))
            coreLocationArray.append(LocationModel(counter: 1, longitude: -122.03529395, latitude: 37.33458564, altitude: 10, speed: 26.24, course: 265.08, horizontalAccuracy: 5.0, verticalAccuracy: 5.0, timestamp: "17-11-2019 10:44:13.136", GPSAccuracy: -1.0))
        }
        coreLocationArray.shuffle()
        #endif
        
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

