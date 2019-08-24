//
//  LocationViewController.swift
//  Sensor App
//
//  Created by Volker Schmitt on 05.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import UIKit
import CoreLocation
import MapKit


// MARK: - Class Definition
class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Initialize Classes
    let locationManager = CLLocationManager() // Location
    let GPS = GPSModel() // GPS
    let settings = SettingsModel() // Settings
    
    
    // MARK: - Variables / Constants
    var GPSSpeedkmhSetting = false // GPS Standard in km/h
    let userDefaults = UserDefaults.standard
    
    
    // MARK: - Outlet
    @IBOutlet weak var GPSLatitudeLabel: UILabel!
    @IBOutlet weak var GPSLongitudeLabel: UILabel!
    @IBOutlet weak var GPSAltitudeLabel: UILabel!
    @IBOutlet weak var GPSDirectionLabel: UILabel!
    @IBOutlet weak var GPSSpeedLabel: UILabel!
    @IBOutlet weak var GPSMapKitView: MKMapView!
    @IBOutlet weak var UIToolBar: UIToolbar!
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        UICustomization() // UI Customization
        
        locationStart(speedSetting: settings.readSpeedSetting()) // Start Location
    }
    
    
    // MARK: - ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        GPS.stopGPS()
    }
    
    
    // MARK: - Actions
    @IBAction func startUpdateLocationButton(_ sender: UIBarButtonItem) {
        viewDidLoad()
    }
    
    
    @IBAction func stopUpdateLocationButton(_ sender: UIBarButtonItem) {
        GPS.stopGPS()
    }
    
    
    // MARK: - Methods
    // LocationStart
    func locationStart(speedSetting: String) {
        GPS.startGPS(_desiredAccuracy: settings.readGPSAccuracySetting()) // Start GPS
        GPS.didUpdatedLocation = {
            // Timestamp into String
            let date = DateFormatter()
            date.timeZone = NSTimeZone(abbreviation: "CET") as TimeZone?
            date.dateFormat = "dd-MM-yyyy - HH:mm:ss.SSS"
            let datestring = date.string(from: self.GPS.timestamp)
            
            
            // Get GPS Variables from Model
            let GPSLatitude = String(format: "%.10f", self.GPS.latitude) // Latitude - Breitengrad
            let GPSLongitude = String(format: "%.10f", self.GPS.longitude) // Longitude - Längengrad
            let GPSHorizontalAccuracy = String(format: "%.2f", self.GPS.horizontalAccuracy) // Horizontal Accuracy
            let GPSAltitude = String(format: "%.2f", self.GPS.altitude) // Altitude - Höhe
            let GPSVerticalAccuracy = String(format: "%.2f", self.GPS.verticalAccuracy) // Vertcal Accuracy
            let GPSSpeed = String(format: "%.2f", self.settings.calculateSpeed(ms: self.GPS.speed, to: "\(SettingsForUserDefaults.GPSSpeedSetting)"))
            let GPSCourse = String(format: "%.5f", self.GPS.course) // Direction of Movement
            let GPSTimestamp = datestring // Timestamp
            let GPSDesiredAccuracy = self.settings.readGPSAccuracySetting() // GPS Accuracy
            
            
            // Print all GPS Variables for Debug
            print("Latitude: \(GPSLatitude)")
            print("Longitude: \(GPSLongitude)")
            print("Horizontal Accuracy: \(GPSHorizontalAccuracy)")
            print("Altitude: \(GPSAltitude)")
            print("VerticalAccuracy: \(GPSVerticalAccuracy)")
            print("Speed in \(self.settings.readSpeedSetting()): \(GPSSpeed)")
            print("Direction: \(GPSCourse)")
            print("Timestamp: \(GPSTimestamp)")
            print("Desired Accuracy: \(GPSDesiredAccuracy)")
            
            
            // Change Labels
            self.GPSLatitudeLabel.text = "Latitude:".localized + " \(GPSLatitude) ° ±\(GPSHorizontalAccuracy)m"
            self.GPSLongitudeLabel.text = "Longitude:".localized + " \(GPSLongitude) ° ±\(GPSHorizontalAccuracy)m"
            self.GPSAltitudeLabel.text = "Altitude:".localized + " \(GPSAltitude) ±\(GPSVerticalAccuracy)m"
            self.GPSDirectionLabel.text = "Direction:".localized + " \(GPSCourse) °"
            self.GPSSpeedLabel.text = "Speed:".localized + "\(GPSSpeed) \(self.settings.readSpeedSetting())"
            

            // MARK: - MapKit
            let locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.GPS.latitude, longitude: self.GPS.longitude)
            
            // Map Types
            self.GPSMapKitView.mapType = MKMapType.standard
            //self.GPSMapKitView.mapType = MKMapType.satellite
            //self.GPSMapKitView.mapType = MKMapType.hybrid
            //self.GPSMapKitView.mapType = MKMapType.satelliteFlyover
            //self.GPSMapKitView.mapType = MKMapType.hybridFlyover
            //self.GPSMapKitView.mapType = MKMapType.mutedStandard
            
            // Map Settings
            self.GPSMapKitView.showsCompass = true
            self.GPSMapKitView.showsBuildings = true
            self.GPSMapKitView.showsTraffic = true
            self.GPSMapKitView.isRotateEnabled = true
            self.GPSMapKitView.isPitchEnabled = true
            
            
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let region = MKCoordinateRegion(center: locValue, span: span)
            self.GPSMapKitView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locValue
        }
    }
    
    
    // MARK: - Customize Background / Label / Button
    func UICustomization() {
        self.view.customizedUIView()
        UIToolBar.customizedToolBar()
        GPSLatitudeLabel.customizedLabel(labelType: "Standard")
        GPSLongitudeLabel.customizedLabel(labelType: "Standard")
        GPSAltitudeLabel.customizedLabel(labelType: "Standard")
        GPSDirectionLabel.customizedLabel(labelType: "Standard")
        GPSSpeedLabel.customizedLabel(labelType: "Standard")
    }
}
