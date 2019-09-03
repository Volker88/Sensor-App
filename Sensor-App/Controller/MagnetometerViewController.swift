//
//  MagnetometerViewController.swift
//  Sensor App
//
//  Created by Volker Schmitt on 25.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import UIKit


// MARK: - TableViewCell Class
class MagnetometerTableViewCell: UITableViewCell {
    @IBOutlet weak var magnetometerTableViewCounter: UILabel!
    @IBOutlet weak var magnetometerTableViewXAxis: UILabel!
    @IBOutlet weak var magnetometerTableViewYAxis: UILabel!
    @IBOutlet weak var magnetometerTableViewZAxis: UILabel!
}


// MARK: - TableViewCell Class
class MagnetometerViewController: UIViewController {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - Define Constants / Variables
    var frequency: Float = SettingsAPI.shared.readFrequency() // Default Frequency
    var dataValues = [MotionModelArray]() // Sensor Data Array
    
    
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
        frequencySliderSetup() // Set up Frequency Slider + Text
        startMotionUpdates() // Initial Start of CoreMotion
    }
    
    
    // MARK: - ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        CoreMotionAPI.shared.motionStopMethod()
    }
    
    
    // MARK: - Actions
    @IBAction func startUpdateMotionButton(_ sender: UIBarButtonItem) {
        CoreMotionAPI.shared.motionStartMethod()
    }
    
    
    @IBAction func stopUpdateMotionButton(_ sender: UIBarButtonItem) {
        CoreMotionAPI.shared.motionStopMethod()
    }
    
    
    @IBAction func motionFrequencyUpdateSlider(_ sender: UISlider) {
        self.frequency = Float(String(format: "%.1f", sender.value))!
        CoreMotionAPI.shared.sensorUpdateInterval = 1 / Double(self.frequency)  // Calculate frequency
        motionUpdateFrequencyLabel.text = "Frequency:".localized + " \(self.frequency) Hz"
    }
    
    
    @IBAction func deleteRecordedData(_ sender: Any) {
        dataValues.removeAll() // Clear Array
        magnetometerTableView.reloadData() // Reload TableView
    }
    
    
    // MARK: - Methods
    func frequencySliderSetup() {
        CoreMotionAPI.shared.sensorUpdateInterval = 1 / Double(self.frequency)  // Calculate frequency
        motionUpdateFrequencyLabel.text = "Frequency:".localized + " \(frequency) Hz" // Setting Label
        motionFrequencySliderOutlet.value = frequency // Setting Slider
    }
    
    
    func startMotionUpdates() {
        CoreMotionAPI.shared.motionStartMethod()
        CoreMotionAPI.shared.motionCompletionHandler = { motion in
            
            // Magnetometer
            self.magnetometerXAxisLabel.text = "X-Axis:".localized + " \(String(format:"%.5f", motion.magnetometerXAxis)) µT"
            self.magnetometerYAxisLabel.text = "Y-Axis:".localized + " \(String(format:"%.5f", motion.magnetometerYAxis)) µT"
            self.magnetometerZAxisLabel.text = "Z-Axis:".localized + " \(String(format:"%.5f", motion.magnetometerZAxis)) µT"
            
            
            // Motion Array
            self.dataValues.insert(MotionModelArray(
                counter: self.dataValues.count + 1,
                timestamp: SettingsAPI.shared.getTimestamp(),
                accelerationXAxis: motion.accelerationXAxis,
                accelerationYAxis: motion.accelerationYAxis,
                accelerationZAxis: motion.accelerationZAxis,
                gravityXAxis: motion.gravityXAxis,
                gravityYAxis: motion.gravityYAxis,
                gravityZAxis: motion.gravityZAxis,
                gyroXAxis: motion.gyroXAxis,
                gyroYAxis: motion.gyroYAxis,
                gyroZAxis: motion.gyroZAxis,
                magnetometerCalibration: motion.magnetometerCalibration,
                magnetometerXAxis: motion.magnetometerXAxis,
                magnetometerYAxis: motion.magnetometerYAxis,
                magnetometerZAxis: motion.magnetometerZAxis,
                attitudeRoll: motion.attitudeRoll,
                attitudePitch: motion.attitudePitch,
                attitudeYaw: motion.attitudeYaw,
                attitudeHeading: motion.attitudeHeading
            ), at: 0)
            self.magnetometerTableView.reloadData() // Reload TableView
        }
    }
}


// MARK: - TableView
extension MagnetometerViewController: UITableViewDataSource, UITableViewDelegate {
    
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
