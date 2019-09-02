//
//  MainViewController.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 05.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import UIKit


// MARK: - Class Definition
class MainViewController: UIViewController {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - Variables / Constants
    
    
    //MARK: - Outlet
    @IBOutlet weak var welcomeMessageTextLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var accelerationButton: UIButton!
    @IBOutlet weak var gravityButton: UIButton!
    @IBOutlet weak var gyroscopeButton: UIButton!
    @IBOutlet weak var attitudeButton: UIButton!
    @IBOutlet weak var magnetometerButton: UIButton!
    @IBOutlet weak var altitudeButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        UICustomization()
        
    }
    
    
    // MARK: - Actions
    
    
    // MARK: - Methods
    
    
    // MARK: - Customize Background / Label / Button
    func UICustomization() {
        self.view.customizedUIView()
        welcomeMessageTextLabel.customizedLabel(labelType: "Header")
        locationButton.customizedButton()
        accelerationButton.customizedButton()
        gravityButton.customizedButton()
        gyroscopeButton.customizedButton()
        attitudeButton.customizedButton()
        attitudeButton.customizedButton()
        magnetometerButton.customizedButton()
        altitudeButton.customizedButton()
        settingsButton.customizedButton()
    }
}
