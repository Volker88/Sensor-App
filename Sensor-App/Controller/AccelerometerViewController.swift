//
//  AccelerometerViewController.swift
//  Sensor App
//
//  Created by Volker Schmitt on 25.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import UIKit


// MARK: - TableViewCell Class
class AccelerationTableViewCell: UITableViewCell {
    @IBOutlet weak var accelerationTableViewCounter: UILabel!
    @IBOutlet weak var accelerationTableViewXAxis: UILabel!
    @IBOutlet weak var accelerationTableViewYAxis: UILabel!
    @IBOutlet weak var accelerationTableViewZAxis: UILabel!
}


// MARK: - Class Definition
class AccelerometerViewController: UIViewController {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - Define Constants / Variables
    var frequency: Float = SettingsAPI.shared.readFrequency() // Default Frequency
    var dataValues = [MotionModelArray]() // Sensor Data Array
    
    
    // MARK: - Outlets
    // Accelerometer
    @IBOutlet weak var accelerometerHeaderLabel: UILabel!
    @IBOutlet weak var accelerometerXAxisLabel: UILabel!
    @IBOutlet weak var accelerometerYAxisLabel: UILabel!
    @IBOutlet weak var accelerometerZAxisLabel: UILabel!
    @IBOutlet weak var accelerometerTableView: UITableView!
    
    
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
        accelerometerTableView.reloadData() // Reload TableView
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
            
            // Acceleration
            self.accelerometerXAxisLabel.text = "X-Axis:".localized + " \(String(format:"%.5f", motion.accelerationXAxis)) m/s^2"
            self.accelerometerYAxisLabel.text = "Y-Axis:".localized + " \(String(format:"%.5f", motion.accelerationYAxis)) m/s^2"
            self.accelerometerZAxisLabel.text = "Z-Axis:".localized + " \(String(format:"%.5f", motion.accelerationZAxis)) m/s^2"
            
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
            self.accelerometerTableView.reloadData() // Reload TableView
        }
    }
}


// MARK: - TableView
extension AccelerometerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataValues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accelerationCell", for: indexPath) as! AccelerationTableViewCell
        
        cell.accelerationTableViewCounter.text = "ID: \(dataValues[indexPath.row].counter)"
        cell.accelerationTableViewXAxis.text = "X: \(String(format:"%.5f", dataValues[indexPath.row].accelerationXAxis))"
        cell.accelerationTableViewYAxis.text = "Y: \(String(format:"%.5f", dataValues[indexPath.row].accelerationYAxis))"
        cell.accelerationTableViewZAxis.text = "Z: \(String(format:"%.5f", dataValues[indexPath.row].accelerationZAxis))"
        
        return cell
    }
    
    
    // MARK: - Customize Background / Label / Button
    func UICustomization() {
        self.view.customizedUIView()
        UIToolBar.customizedToolBar()
        accelerometerHeaderLabel.customizedLabel(labelType: "Header")
        accelerometerXAxisLabel.customizedLabel(labelType: "Standard")
        accelerometerYAxisLabel.customizedLabel(labelType: "Standard")
        accelerometerZAxisLabel.customizedLabel(labelType: "Standard")
        motionHeaderLabel.customizedLabel(labelType: "Header")
        motionUpdateFrequencyLabel.customizedLabel(labelType: "Standard")
        motionMinLabel.customizedLabel(labelType: "Standard")
        motionMaxLabel.customizedLabel(labelType: "Standard")
        accelerometerTableView.customizedTableView()
    }
}
