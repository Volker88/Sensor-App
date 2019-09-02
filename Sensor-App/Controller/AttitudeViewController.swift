//
//  AttitudeViewController.swift
//  Sensor App
//
//  Created by Volker Schmitt on 25.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import UIKit
import CoreMotion


// MARK: - TableViewCell Class
class AttitudeTableViewCell: UITableViewCell {
    @IBOutlet weak var attitudeTableViewCounter: UILabel!
    @IBOutlet weak var attitudeTableViewRoll: UILabel!
    @IBOutlet weak var attitudeTableViewPitch: UILabel!
    @IBOutlet weak var attitudeTableViewYaw: UILabel!
    @IBOutlet weak var attitudeTableViewHeading: UILabel!
}


// MARK: - Class Definition
class AttitudeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Initialize Classes
    let motionManager = CoreMotionModel()
    
    
    // MARK: - Define Constants / Variables
    var frequency: Float = 1.0 // Default Frequency
    var dataValues = [DataArray]() // Sensor Data Array
    
    
    // MARK: - Outlets
    
    // Attitude
    @IBOutlet weak var attitudeHeaderLabel: UILabel!
    @IBOutlet weak var attitudeRollLabel: UILabel!
    @IBOutlet weak var attitudePitchLabel: UILabel!
    @IBOutlet weak var attitudeYawLabel: UILabel!
    @IBOutlet weak var attitudeHeadingLabel: UILabel!
    @IBOutlet weak var attitudeTableView: UITableView!
    
    
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
        self.frequency = SettingsAPI.shared.readFrequency() // Update Motion Frequency
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
        attitudeTableView.reloadData() // Reload TableView
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
            
            // Attitude
            self.attitudeRollLabel.text = "Roll:".localized + " \(String(format:"%.5f", self.motionManager.attitudeRoll * 180 / .pi)) °"
            self.attitudePitchLabel.text = "Pitch:".localized + " \(String(format:"%.5f", self.motionManager.attitudePitch * 180 / .pi)) °"
            self.attitudeYawLabel.text = "Yaw:".localized + " \(String(format:"%.5f", self.motionManager.attitudeYaw * 180 / .pi)) °"
            self.attitudeHeadingLabel.text = "Heading:".localized + " \(String(format:"%.5f", self.motionManager.attitudeHeading)) °" // Localization
            
            
            // Attitude Array
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
            
            self.attitudeTableView.reloadData() // Reload TableView
        }
    }
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataValues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attitudeCell", for: indexPath) as! AttitudeTableViewCell
        
        cell.attitudeTableViewCounter.text = "ID: \(dataValues[indexPath.row].counter)"
        cell.attitudeTableViewRoll.text = "R: \(String(format:"%.5f", dataValues[indexPath.row].attitudeRoll))"
        cell.attitudeTableViewPitch.text = "P: \(String(format:"%.5f", dataValues[indexPath.row].attitudePitch))"
        cell.attitudeTableViewYaw.text = "Y: \(String(format:"%.5f", dataValues[indexPath.row].attitudeYaw))"
        cell.attitudeTableViewHeading.text = "H: \(String(format:"%.5f", dataValues[indexPath.row].attitudeHeading))"
        
        return cell
    }
    
    
    // MARK: - Customize Background / Label / Button
    func UICustomization() {
        self.view.customizedUIView()
        UIToolBar.customizedToolBar()
        attitudeHeaderLabel.customizedLabel(labelType: "Header")
        attitudeRollLabel.customizedLabel(labelType: "Standard")
        attitudePitchLabel.customizedLabel(labelType: "Standard")
        attitudeYawLabel.customizedLabel(labelType: "Standard")
        attitudeHeadingLabel.customizedLabel(labelType: "Standard")
        motionHeaderLabel.customizedLabel(labelType: "Header")
        motionUpdateFrequencyLabel.customizedLabel(labelType: "Standard")
        motionMinLabel.customizedLabel(labelType: "Standard")
        motionMaxLabel.customizedLabel(labelType: "Standard")
        attitudeTableView.customizedTableView()
    }
}
