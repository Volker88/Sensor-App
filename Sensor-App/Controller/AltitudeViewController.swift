//
//  AltitudeViewController.swift
//  Sensor App
//
//  Created by Volker Schmitt on 25.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import UIKit
import CoreMotion


// MARK: - TableViewCell Class
class AltitudeTableViewCell: UITableViewCell {
    @IBOutlet weak var altitudeTableViewCounter: UILabel!
    @IBOutlet weak var altitudeTableViewPressure: UILabel!
    @IBOutlet weak var altitudeTableViewAltitudeChange: UILabel!
}


// MARK: - Class Definition
class AltitudeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Initialize Classes
    let motionManager = CoreMotionModel()
    let settings = SettingsModel() // Settings
    
    
    // MARK: - Define Constants / Variables
    var frequency: Float = 1.0 // Default Frequency
    var dataValues = [DataArray]() // Sensor Data Array
    
    
    // Struct for Tableview Data
    struct dataArray {
        var counter = [Int]() // ID Counter
        var timestamp = [String]() // Timestamp
        var pressure = [String]() // Pressure values
        var altitudeChange = [String]() // Altitude Change values
    }
    
    
    // MARK: - Outlets
    // Altitude
    @IBOutlet weak var altitudeHeaderLabel: UILabel!
    @IBOutlet weak var altitudePressureLabel: UILabel!
    @IBOutlet weak var altitudeHeightChangeLabel: UILabel!
    @IBOutlet weak var altitudeTableView: UITableView!
    @IBOutlet weak var UIToolBar: UIToolbar!
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        UICustomization() // UI Customization
        initialStart() // Initial Start of CoreMotion
    }
    
    
    // MARK: - ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        motionManager.motionStopMethod()
    }
    
    
    // MARK: - Actions
    @IBAction func startUpdateMotionButton(_ sender: UIBarButtonItem) {
        motionManagerStart()
    }
    
    
    @IBAction func stopUpdateMotionButton(_ sender: UIBarButtonItem) {
        motionManager.motionStopMethod()
    }
    
    
    
    @IBAction func deleteRecordedData(_ sender: Any) {
        dataValues.removeAll() // Clear Array
        altitudeTableView.reloadData() // Reload TableView
    }
    
    
    // MARK: - Methods
    func initialStart() {
        motionManagerStart() // Motion Start
    }
    
    
    func motionManagerStart() {
        // Start Motion
        motionManager.motionStartMethod()
        
        // Update Labels
        motionManager.didUpdatedCoreMotion = {
            
            // Get Calculated Pressure + Altitude change date
            let altitude = self.getAltitudeData(pressure: self.motionManager.pressureValue, height: self.motionManager.relativeAltitudeValue)
            
            // Attitude
            self.altitudePressureLabel.text = "Pressure:".localized + " \(String(format:"%.5f", altitude.convertedPressure)) \(self.settings.readPressureSetting())"
            self.altitudeHeightChangeLabel.text = "Altitude Change:".localized + " \(String(format:"%.2f", altitude.convertedHeight)) \(self.settings.readHeightSetting())"
            
            
            // Altitude Arrays
            self.dataValues.insert(DataArray(
                counter: self.dataValues.count + 1,
                timestamp: self.motionManager.getTimestamp(),
                accelerationXAxis: self.motionManager.accelerationX,
                accelerationYAxis: self.motionManager.accelerationY,
                accelerationZAxis: self.motionManager.accelerationZ,
                gravityXAxis: self.motionManager.gravityX,
                gravityYAxis: self.motionManager.gravityY,
                gravityZAxis: self.motionManager.gravityZ,
                gyroXAxis: self.motionManager.gyroX,
                gyroYAxis: self.motionManager.gyroX,
                gyroZAxis: self.motionManager.gyroX,
                magnetometerCalibration: self.motionManager.magnetometerCalibration,
                magnetometerXAxis: self.motionManager.magnetometerX,
                magnetometerYAxis: self.motionManager.magnetometerY,
                magnetometerZAxis: self.motionManager.magnetometerZ,
                attitudeRoll: (self.motionManager.attitudeRoll * 180 / .pi),
                attitudePitch: (self.motionManager.attitudePitch * 180 / .pi),
                attitudeYaw: (self.motionManager.attitudeYaw * 180 / .pi),
                attitudeHeading: self.motionManager.attitudeHeading,
                pressureValue: self.motionManager.pressureValue,
                relativeAltitudeValue: self.motionManager.relativeAltitudeValue
            ), at: 0)
            
            self.altitudeTableView.reloadData() // Reload TableView
        }
    }
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataValues.count
    }
    
    
    func getAltitudeData(pressure: Double, height: Double) -> (convertedPressure: Double, convertedHeight: Double) {
        let altitudePressureSetting = settings.readPressureSetting()
        let altitudeHeightSetting = settings.readHeightSetting()
        
        let pressure = settings.calculatePressure(pressure: pressure, to: altitudePressureSetting)
        let height = settings.calculateHeight(height: height, to: altitudeHeightSetting)
        
        return (pressure, height)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "altitudeCell", for: indexPath) as! AltitudeTableViewCell
        
        cell.altitudeTableViewCounter.text = "ID: \(dataValues[indexPath.row].counter)"
        cell.altitudeTableViewPressure.text = "P:".localized + "\(String(format:"%.5f", dataValues[indexPath.row].pressureValue))"
        cell.altitudeTableViewAltitudeChange.text = "A:".localized + "\(String(format:"%.5f", dataValues[indexPath.row].relativeAltitudeValue))"
        
        return cell
    }
    
    
    // MARK: - Customize Background / Label / Button
    func UICustomization() {
        self.view.customizedUIView()
        UIToolBar.customizedToolBar()
        altitudeHeaderLabel.customizedLabel(labelType: "Header")
        altitudePressureLabel.customizedLabel(labelType: "Standard")
        altitudeHeightChangeLabel.customizedLabel(labelType: "Standard")
        altitudeTableView.customizedTableView()
    }
}



