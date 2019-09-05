//
//  AttitudeViewController.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 25.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import UIKit


// MARK: - TableViewCell Class
class AttitudeTableViewCell: UITableViewCell {
    @IBOutlet weak var attitudeTableViewCounter: UILabel!
    @IBOutlet weak var attitudeTableViewRoll: UILabel!
    @IBOutlet weak var attitudeTableViewPitch: UILabel!
    @IBOutlet weak var attitudeTableViewYaw: UILabel!
    @IBOutlet weak var attitudeTableViewHeading: UILabel!
}


// MARK: - Class Definition
class AttitudeViewController: UIViewController {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - Define Constants / Variables
    var frequency: Float = SettingsAPI.shared.readFrequency() // Default Frequency
    
    
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
        attitudeTableView.dataSource = self
        attitudeTableView.delegate = self
        
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
            self.attitudeTableView.reloadData() // Reload TableView
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
            
            guard let attitudeRoll = motion.first?.attitudeRoll else { return }
            guard let attitudePitch = motion.first?.attitudePitch else { return }
            guard let attitudeYaw = motion.first?.attitudeYaw else { return }
            guard let attitudeHeading = motion.first?.attitudeHeading else { return }
            
            // Change Attitude Labels
            self.attitudeRollLabel.text = "Roll:".localized + " \(String(format:"%.5f", attitudeRoll * 180 / .pi)) °"
            self.attitudePitchLabel.text = "Pitch:".localized + " \(String(format:"%.5f", attitudePitch * 180 / .pi)) °"
            self.attitudeYawLabel.text = "Yaw:".localized + " \(String(format:"%.5f", attitudeYaw * 180 / .pi)) °"
            self.attitudeHeadingLabel.text = "Heading:".localized + " \(String(format:"%.5f", attitudeHeading)) °"
            
            // Reload TableView
            self.attitudeTableView.reloadData()
        }
    }
}


// MARK: - TableView
extension AttitudeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreMotionAPI.shared.motionModelArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attitudeCell", for: indexPath) as! AttitudeTableViewCell
        
        cell.attitudeTableViewCounter.text = "ID: \(CoreMotionAPI.shared.motionModelArray[indexPath.row].counter)"
        cell.attitudeTableViewRoll.text = "R: \(String(format:"%.5f", CoreMotionAPI.shared.motionModelArray[indexPath.row].attitudeRoll))"
        cell.attitudeTableViewPitch.text = "P: \(String(format:"%.5f", CoreMotionAPI.shared.motionModelArray[indexPath.row].attitudePitch))"
        cell.attitudeTableViewYaw.text = "Y: \(String(format:"%.5f", CoreMotionAPI.shared.motionModelArray[indexPath.row].attitudeYaw))"
        cell.attitudeTableViewHeading.text = "H: \(String(format:"%.5f", CoreMotionAPI.shared.motionModelArray[indexPath.row].attitudeHeading))"
        
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
