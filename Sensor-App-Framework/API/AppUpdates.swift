//
//  AppUpdates.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import Foundation


// MARK: - Class Definition
class AppUpdates {
    
    
    // MARK: - Methods
    ///
    ///  Call this function to check if the app version is up to date
    ///
    public func checkForUpdate() {
        
        let upToDate = UserDefaults.standard.bool(forKey: "upToDate")
        
        if upToDate == true {
            print("App is up to date!")
        } else if upToDate == false {
            updateApp()
        }
    }
    
    ///
    ///  Method to update the app
    ///
    ///  This function will clear old userDefaults and set "upToDate" to true
    ///
    ///
    ///  - Note: Add additional tasks which need to be performed with a new app version
    ///
    private func updateApp() {
        SettingsAPI.shared.clearUserDefaults()
        UserDefaults.standard.set(true, forKey: "upToDate")
        print("App has been updated")
    }
    
    ///
    ///  Call this method to get the current app version number
    ///
    ///  - Returns: App Version
    ///
    private func getCurrentAppVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        let version = (appVersion as! String)
        
        return version
    }
}
