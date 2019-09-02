//
//  SettingsViewController.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 24.07.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import UIKit
import ProgressHUD


// MARK: - Class Definition
class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - Variables / Constants
    var GPSSpeedSetting: String = "m/s"
    var GPSAccuracySetting: String = "Best"
    var altitudePressureSetting: String = "bar"
    var altitudeHeightSetting: String = "m"
    var updateFrequency: Float = 1.0
    
    
    // MARK: - Outlet
    @IBOutlet weak var UIToolBar: UIToolbar!
    
    // Location
    @IBOutlet weak var locationHeaderLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedPickerView: UIPickerView!
    @IBOutlet weak var GPSAccuracyLabel: UILabel!
    @IBOutlet weak var GPSAccuracyPickerView: UIPickerView!
    
    // Altitude
    @IBOutlet weak var altitudeHeaderLabel: UILabel!
    @IBOutlet weak var altitudePressureLabel: UILabel!
    @IBOutlet weak var pressurePickerView: UIPickerView!
    @IBOutlet weak var altitudeHeightLabel: UILabel!
    @IBOutlet weak var altitudeHeightPickerView: UIPickerView!
    
    
    // Refresh Rate
    @IBOutlet weak var motionHeaderLabel: UILabel!
    @IBOutlet weak var motionUpdateFrequencyLabel: UILabel!
    @IBOutlet weak var frequencyUpdateSliderOutlet: UISlider!
    @IBOutlet weak var motionMinLabel: UILabel!
    @IBOutlet weak var motionMaxLabel: UILabel!
    
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        UICustomization() // UI Customization
        
        // Set defaults from saved values in UserDefaults
        pickerViewDefault(setting: SettingsForUserDefaults.GPSSpeedSetting)
        pickerViewDefault(setting: SettingsForUserDefaults.GPSAccuracySetting)
        pickerViewDefault(setting: SettingsForUserDefaults.pressureSetting)
        pickerViewDefault(setting: SettingsForUserDefaults.altitudeHeightSetting)
        getUpdateFrequency()
    }
    
    
    // MARK: - ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
    // MARK: - Actions
    @IBAction func frequencyUpdateSliderMoved(_ sender: UISlider) { // Move Slider
        self.updateFrequency = Float(String(format: "%.1f", sender.value))!
        self.motionUpdateFrequencyLabel.text = "Frequency:".localized + " \(self.updateFrequency) Hz"
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) { // Save Settings
        SettingsAPI.shared.saveUserDefaultsString(input: GPSSpeedSetting, setting: SettingsForUserDefaults.GPSSpeedSetting)
        SettingsAPI.shared.saveUserDefaultsString(input: GPSAccuracySetting, setting: SettingsForUserDefaults.GPSAccuracySetting)
        SettingsAPI.shared.saveUserDefaultsString(input: altitudePressureSetting, setting: SettingsForUserDefaults.pressureSetting)
        SettingsAPI.shared.saveUserDefaultsString(input: altitudeHeightSetting, setting: SettingsForUserDefaults.altitudeHeightSetting)
        SettingsAPI.shared.saveFrequency(frequency: updateFrequency)
        let status = "Successfully saved!".localized
        ProgressHUD.showSuccess(status)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) { // Set defaults from saved values in UserDefaults
        pickerViewDefault(setting: SettingsForUserDefaults.GPSSpeedSetting)
        pickerViewDefault(setting: SettingsForUserDefaults.GPSAccuracySetting)
        pickerViewDefault(setting: SettingsForUserDefaults.pressureSetting)
        pickerViewDefault(setting: SettingsForUserDefaults.altitudeHeightSetting)
        getUpdateFrequency()
        let status = "Changes discarded!".localized
        ProgressHUD.showSuccess(status)
    }
    
    
    // Mark: - PickerView
    // Qty of Columns for PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Qty of items to show
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1: return SettingsAPI.shared.GPSspeedSettings.count
        case 2: return SettingsAPI.shared.GPSAccuracyOptions.count
        case 3: return SettingsAPI.shared.altitudePressure.count
        case 4: return SettingsAPI.shared.altitudeHeight.count
        default: return 1
        }
    }
    
    
    // Show Text
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowTitle = ""
        switch pickerView.tag {
        case 1: rowTitle = SettingsAPI.shared.GPSspeedSettings[row]
        case 2: rowTitle = SettingsAPI.shared.GPSAccuracyOptions[row]
        case 3: rowTitle = SettingsAPI.shared.altitudePressure[row]
        case 4: rowTitle = SettingsAPI.shared.altitudeHeight[row]
        default: rowTitle = "Error"
        }
        return rowTitle
    }
    
    
    // Selected Row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1: GPSSpeedSetting = SettingsAPI.shared.GPSspeedSettings[row]
        case 2: GPSAccuracySetting = SettingsAPI.shared.GPSAccuracyOptions[row]
        case 3: altitudePressureSetting = SettingsAPI.shared.altitudePressure[row]
        case 4: altitudeHeightSetting = SettingsAPI.shared.altitudeHeight[row]
        default: print("Error")
        }
    }
    
    
    // MARK: - Methods for PickerView Default
    func defaultSettingForPickerView(key: String, setting: SettingsForUserDefaults) -> Int {
        var settingsDefaultIndex = 0
        
        if setting == SettingsForUserDefaults.GPSSpeedSetting {
            for item in SettingsAPI.shared.GPSspeedSettings {
                settingsDefaultIndex += 1
                if item == key {
                    break // Search sucessful -> finish loop
                }
            }
        } else if setting == SettingsForUserDefaults.GPSAccuracySetting {
            for item in SettingsAPI.shared.GPSAccuracyOptions {
                settingsDefaultIndex += 1
                if item == key {
                    break // Search sucessful -> finish loop
                }
            }
        } else if setting == SettingsForUserDefaults.pressureSetting {
            for item in SettingsAPI.shared.altitudePressure {
                settingsDefaultIndex += 1
                if item == key {
                    break // Search sucessful -> finish loop
                }
            }
        } else if setting == SettingsForUserDefaults.altitudeHeightSetting {
            for item in SettingsAPI.shared.altitudeHeight {
                settingsDefaultIndex += 1
                if item == key {
                    break // Search sucessful -> finish loop
                }
            }
        }
        return settingsDefaultIndex // return Array Index
    }
    
    
    func pickerViewDefault(setting: SettingsForUserDefaults) {
        if let i = SettingsAPI.shared.userDefaults.string(forKey: "\(setting)") {
            let pickerIndex = defaultSettingForPickerView(key: i, setting: setting)
            switch setting {
            case SettingsForUserDefaults.GPSSpeedSetting: self.speedPickerView.selectRow(pickerIndex - 1, inComponent: 0, animated: true)
            case SettingsForUserDefaults.GPSAccuracySetting: self.GPSAccuracyPickerView.selectRow(pickerIndex - 1, inComponent: 0, animated: true)
            case SettingsForUserDefaults.pressureSetting: self.pressurePickerView.selectRow(pickerIndex - 1, inComponent: 0, animated: true)
            case SettingsForUserDefaults.altitudeHeightSetting: self.altitudeHeightPickerView.selectRow(pickerIndex - 1, inComponent: 0, animated: true)
            default: print("error")
            }
            print("Read: - Index: \(pickerIndex - 1) - Setting: \(i)")
        }
    }
    
    
    // MARK: - Methods
    func getUpdateFrequency() {
        updateFrequency = SettingsAPI.shared.readFrequency() // Read update frequency
        frequencyUpdateSliderOutlet.value = updateFrequency
        self.motionUpdateFrequencyLabel.text = "Frequency:".localized + " \(self.updateFrequency) Hz"
        print("Read: - Setting: \(self.updateFrequency)")
    }
    
    
    // MARK: - Customize Background / Label / Button
    func UICustomization() {
        self.view.customizedUIView()
        UIToolBar.customizedToolBar()
        
        // Location
        locationHeaderLabel.customizedLabel(labelType: "Header")
        speedLabel.customizedLabel(labelType: "Standard")
        GPSAccuracyLabel.customizedLabel(labelType: "Standard")
        
        // Altitude
        altitudeHeaderLabel.customizedLabel(labelType: "Header")
        altitudePressureLabel.customizedLabel(labelType: "Standard")
        altitudeHeightLabel.customizedLabel(labelType: "Standard")
        
        // Refresh Rate
        motionHeaderLabel.customizedLabel(labelType: "Header")
        motionUpdateFrequencyLabel.customizedLabel(labelType: "Standard")
        motionMinLabel.customizedLabel(labelType: "Standard")
        motionMaxLabel.customizedLabel(labelType: "Standard")
    }
}
