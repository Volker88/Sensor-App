//
//  AccelerometerViewController.swift
//  Sensor-App
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
        accelerometerTableView.dataSource = self
        accelerometerTableView.delegate = self
        
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
        CoreMotionAPI.shared.clearMotionArray {
            self.accelerometerTableView.reloadData() // Reload TableView
        }
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

            guard let accelerationX = motion.first?.accelerationXAxis else { return }
            guard let accelerationY = motion.first?.accelerationYAxis else { return }
            guard let accelerationZ = motion.first?.accelerationZAxis else { return }
            
            // Change Acceleration Labels
            self.accelerometerXAxisLabel.text = "X-Axis:".localized + " \(String(format:"%.5f", accelerationX)) m/s^2"
            self.accelerometerYAxisLabel.text = "Y-Axis:".localized + " \(String(format:"%.5f", accelerationY)) m/s^2"
            self.accelerometerZAxisLabel.text = "Z-Axis:".localized + " \(String(format:"%.5f", accelerationZ)) m/s^2"
            
            // Reload TableView
            self.accelerometerTableView.reloadData()
        }
    }
}


// MARK: - TableView
extension AccelerometerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreMotionAPI.shared.motionModelArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accelerationCell", for: indexPath) as! AccelerationTableViewCell
        
        cell.accelerationTableViewCounter.text = "ID: \(CoreMotionAPI.shared.motionModelArray[indexPath.row].counter)"
        cell.accelerationTableViewXAxis.text = "X: \(String(format:"%.5f", CoreMotionAPI.shared.motionModelArray[indexPath.row].accelerationXAxis))"
        cell.accelerationTableViewYAxis.text = "Y: \(String(format:"%.5f", CoreMotionAPI.shared.motionModelArray[indexPath.row].accelerationYAxis))"
        cell.accelerationTableViewZAxis.text = "Z: \(String(format:"%.5f", CoreMotionAPI.shared.motionModelArray[indexPath.row].accelerationZAxis))"
        
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
