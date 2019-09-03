//
//  AltitudeViewController.swift
//  Sensor App
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
    var dataValues = [AltitudeModelArray]() // Sensor Data Array
    
    
    
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
        dataValues.removeAll() // Clear Array
        altitudeTableView.reloadData() // Reload TableView
    }
    
    
    // MARK: - Methods
    func startMotionUpdates() {
        CoreMotionAPI.shared.motionStartMethod()
        CoreMotionAPI.shared.altitudeCompletionHandler = { motion in
            
            // Get Calculated Pressure + Altitude change date
            let altitude = CalculationAPI.shared.convertAltitudeData(pressure: motion.pressureValue, height: motion.relativeAltitudeValue)
            
            // Attitude
            self.altitudePressureLabel.text = "Pressure:".localized + " \(String(format:"%.5f", altitude.convertedPressure)) \(SettingsAPI.shared.readPressureSetting())"
            self.altitudeHeightChangeLabel.text = "Altitude Change:".localized + " \(String(format:"%.5f", altitude.convertedHeight)) \(SettingsAPI.shared.readHeightSetting())"
            
            
            // Motion Array
            self.dataValues.insert(AltitudeModelArray(
                counter: self.dataValues.count + 1,
                timestamp: SettingsAPI.shared.getTimestamp(),
                pressureValue: altitude.convertedPressure,
                relativeAltitudeValue: altitude.convertedHeight
            ), at: 0)
            self.altitudeTableView.reloadData() // Reload TableView
        }
    }
}


// MARK: - TableView
extension AltitudeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataValues.count
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



