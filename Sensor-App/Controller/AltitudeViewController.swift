//
//  AltitudeViewController.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 25.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import UIKit


// MARK: - TableViewCell Class
class AltitudeTableViewCell: UITableViewCell {
    @IBOutlet weak var altitudeTableViewCounter: UILabel!
    @IBOutlet weak var altitudeTableViewPressure: UILabel!
    @IBOutlet weak var altitudeTableViewAltitudeChange: UILabel!
}


// MARK: - Class Definition
class AltitudeViewController: UIViewController {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - Define Constants / Variables
    var frequency: Float = SettingsAPI.shared.readFrequency() // Default Frequency
    
    
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
        altitudeTableView.dataSource = self
        altitudeTableView.delegate = self
        
        UICustomization() // UI Customization
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
    
    
    
    @IBAction func deleteRecordedData(_ sender: Any) {
        CoreMotionAPI.shared.clearMotionArray {
            self.altitudeTableView.reloadData() // Reload TableView
        }
    }
    
    
    // MARK: - Methods
    func startMotionUpdates() {
        CoreMotionAPI.shared.motionStartMethod()
        CoreMotionAPI.shared.altitudeCompletionHandler = { motion in
            
            guard let pressure = motion.first?.pressureValue else { return }
            guard let altitude = motion.first?.relativeAltitudeValue else { return }
            
            // Change Altitude Labels
            self.altitudePressureLabel.text = "Pressure:".localized + " \(String(format:"%.5f", pressure)) \(SettingsAPI.shared.readPressureSetting())"
            self.altitudeHeightChangeLabel.text = "Altitude Change:".localized + " \(String(format:"%.5f", altitude)) \(SettingsAPI.shared.readHeightSetting())"
            
            
            // Reload TableView
            self.altitudeTableView.reloadData()
        }
    }
}


// MARK: - TableView
extension AltitudeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreMotionAPI.shared.altitudeModelArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "altitudeCell", for: indexPath) as! AltitudeTableViewCell
        
        cell.altitudeTableViewCounter.text = "ID: \(CoreMotionAPI.shared.altitudeModelArray[indexPath.row].counter)"
        cell.altitudeTableViewPressure.text = "P:".localized + "\(String(format:"%.5f", CoreMotionAPI.shared.altitudeModelArray[indexPath.row].pressureValue))"
        cell.altitudeTableViewAltitudeChange.text = "A:".localized + "\(String(format:"%.5f", CoreMotionAPI.shared.altitudeModelArray[indexPath.row].relativeAltitudeValue))"
        
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



