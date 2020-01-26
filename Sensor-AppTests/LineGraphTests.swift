//
//  LineGraphTests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 25.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import XCTest
@testable import Sensor_App


// MARK: - Class Definition
class LineGraphTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
     
    
    // MARK: - LineGraphView
    func testLineGraphViewPerformanceOnLocationView() {
        //Given
        let locationVM = CoreLocationViewModel()
        
        //When
        locationVM.coreLocationArray = generateCoreLocationModelArray()
        
        //Then
        print("Items in LocationArray: \(locationVM.coreLocationArray.count)")
        
        //Measure
        measure {
            _ = LineGraphSubView(locationVM: locationVM, showGraph: .latitude)
        }
    }
    
    func testLineGraphViewPerformanceOnAccelerationView() {
        //Given
        let motionVM = CoreMotionViewModel()
        
        //When
        motionVM.coreMotionArray = generateCoreMotionModelArray()
        
        //Then
        print("Items in MotionArray: \(motionVM.coreMotionArray.count)")
        
        //Measure
        measure {
            _ = LineGraphSubView(motionVM: motionVM, showGraph: .accelerationXAxis)
        }
    }
    
    func testLineGraphViewPerformanceOnAltitudeView() {
        //Given
        let motionVM = CoreMotionViewModel()
        
        //When
        motionVM.altitudeArray = generateCoreMotionModelAltitudeArray()
        
        //Then
        print("Items in AltitudeArray: \(motionVM.altitudeArray.count)")
        
        //Measure
        measure {
            _ = LineGraphSubView(motionVM: motionVM, showGraph: .pressureValue)
        }
    }
    
    
    // MARK: - Methods
    func generateCoreLocationModelArray() -> [LocationModel] {
        var locationArray = [LocationModel]()
        for index in 1...10000 {
            let array = LocationModel(counter: index, longitude: 23.233245, latitude: -150.23321, altitude: 10.23345, speed: 29.999, course: 250.24424, horizontalAccuracy: 55.5555, verticalAccuracy: 55.5555, timestamp: "2020-01-01 00:00:00", GPSAccuracy: 20.222)
            
            locationArray.append(array)
        }
        return locationArray
    }
    
    func generateCoreMotionModelArray() -> [MotionModel] {
        var motionArray = [MotionModel]()
        for index in 1...10000 {
            let array = MotionModel(counter: index, timestamp: SettingsAPI.shared.getTimestamp(), accelerationXAxis: 0.01624, accelerationYAxis: 0.53212, accelerationZAxis: 1.60932, gravityXAxis: -0.80520, gravityYAxis: -0.01717, gravityZAxis: -0.59275, gyroXAxis: 0.00140, gyroYAxis: -0.00045, gyroZAxis: 0.00140, magnetometerCalibration: 2, magnetometerXAxis: -2.14823, magnetometerYAxis: 35.9243, magnetometerZAxis: -21.61115, attitudeRoll: -0.9362, attitudePitch: 0.0171, attitudeYaw: -1.1931, attitudeHeading: 338.8594)
                
            motionArray.append(array)
        }
        return motionArray
    }
    
    func generateCoreMotionModelAltitudeArray() -> [AltitudeModel] {
        var altitudeArray = [AltitudeModel]()
        for index in 1...10000 {
            let array = AltitudeModel(counter: index, timestamp: SettingsAPI.shared.getTimestamp(), pressureValue: 0.9961142, relativeAltitudeValue: 0.0)
                
            altitudeArray.append(array)
        }
        return altitudeArray
    }   
}
