//
//  MagnetometerViewController.swift
//  Sensor App
//
//  Created by Volker Schmitt on 25.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import UIKit
import CoreMotion


// MARK: - TableViewCell Class
class MagnetometerTableViewCell: UITableViewCell {
    @IBOutlet weak var magnetometerTableViewCounter: UILabel!
    @IBOutlet weak var magnetometerTableViewXAxis: UILabel!
    @IBOutlet weak var magnetometerTableViewYAxis: UILabel!
    @IBOutlet weak var magnetometerTableViewZAxis: UILabel!
}


// MARK: - TableViewCell Class
class MagnetometerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Initialize Classes
    let motionManager = CoreMotionModel()
    let settings = SettingsModel() // Settings
    
    
    // MARK: - Define Constants / Variables
    var frequency: Float = 1.0 // Default Frequency
    var dataValues = [DataArray]() // Sensor Data Array
    
    
    // MARK: - Outlets
    // Magnetometer
    @IBOutlet weak var magnetometerHeaderLabel: UILabel!
    @IBOutlet weak var magnetometerXAxisLabel: UILabel!
    @IBOutlet weak var magnetometerYAxisLabel: UILabel!
    @IBOutlet weak var magnetometerZAxisLabel: UILabel!
    @IBOutlet weak var magnetometerTableView: UITableView!
    
    
    // Refresh Rate
    @IBOutlet weak var motionHeaderLabel: UILabel!
    @IBOutlet weak var motionUpdateFrequencyLabel: UILabel!
    @IBOutlet weak var motionFrequencySliderOutlet: UISlider!
    @IBOutlet weak var motionMinLabel: UILabel!
    @IBOutlet weak var motionMaxLabel: UILabel!
    @IBOutlet weak var UIToolBar: UIToolbar!
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        UICustomization() // UI Customization
        self.frequency = settings.readFrequency() // Update Motion Frequency
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
    
    
    @IBAction func motionFrequencyUpdateSlider(_ sender: UISlider) {
        self.frequency = Float(String(format: "%.1f", sender.value))!
        motionManager.sensorUpdateInterval = 1 / Double(self.frequency)  // Calculate frequency
        motionUpdateFrequencyLabel.text = "Frequency:".localized + " \(self.frequency) Hz"
    }
    
    
    @IBAction func deleteRecordedData(_ sender: Any) {
        dataValues.removeAll() // Clear Array
        magnetometerTableView.reloadData() // Reload TableView
    }
    
    
    // MARK: - Methods
    func initialStart() {
        motionManager.sensorUpdateInterval = 1 / Double(self.frequency)  // Calculate frequency
        motionUpdateFrequencyLabel.text = "Frequency:".localized + " \(frequency) Hz" // Setting Label
        motionFrequencySliderOutlet.value = frequency // Setting Slider
        motionManagerStart() // Motion Start
    }
    
    
    func motionManagerStart() {
        // Start Motion
        motionManager.motionStartMethod()
        
        // Update Labels
        motionManager.didUpdatedCoreMotion = {
            
            // Magnetometer
            self.magnetometerXAxisLabel.text = "X-Axis:".localized + " \(String(format:"%.5f", self.motionManager.magnetometerX)) µT"
            self.magnetometerYAxisLabel.text = "Y-Axis:".localized + " \(String(format:"%.5f", self.motionManager.magnetometerY)) µT"
            self.magnetometerZAxisLabel.text = "Z-Axis:".localized + " \(String(format:"%.5f", self.motionManager.magnetometerZ)) µT"
            
            
            // Magnetometer Arrays
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
            
            self.magnetometerTableView.reloadData() // Reload TableView
        }
    }
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataValues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "magnetometerCell", for: indexPath) as! MagnetometerTableViewCell
        
        cell.magnetometerTableViewCounter.text = "ID: \(dataValues[indexPath.row].counter)"
        cell.magnetometerTableViewXAxis.text = "X: \(String(format:"%.5f", dataValues[indexPath.row].magnetometerXAxis))"
        cell.magnetometerTableViewYAxis.text = "Y: \(String(format:"%.5f", dataValues[indexPath.row].magnetometerYAxis))"
        cell.magnetometerTableViewZAxis.text = "Z: \(String(format:"%.5f", dataValues[indexPath.row].magnetometerZAxis))"
        
        return cell
    }
    
    
    // MARK: - Customize Background / Label / Button
    func UICustomization() {
        self.view.customizedUIView()
        UIToolBar.customizedToolBar()
        magnetometerHeaderLabel.customizedLabel(labelType: "Header")
        magnetometerXAxisLabel.customizedLabel(labelType: "Standard")
        magnetometerYAxisLabel.customizedLabel(labelType: "Standard")
        magnetometerZAxisLabel.customizedLabel(labelType: "Standard")
        motionHeaderLabel.customizedLabel(labelType: "Header")
        motionUpdateFrequencyLabel.customizedLabel(labelType: "Standard")
        motionMinLabel.customizedLabel(labelType: "Standard")
        motionMaxLabel.customizedLabel(labelType: "Standard")
        magnetometerTableView.customizedTableView()
    }
}
