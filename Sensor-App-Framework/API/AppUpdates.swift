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
    
    // MARK: - Initialize Classes
    let settings = SettingsAPI()
    
    
    // MARK: - Methods
    ///
    ///  Call this function to check if the app version is up to date
    ///
    public func checkForUpdate() {
        
        let appVersion = UserDefaults.standard.string(forKey: "CurrentAppVersion")
           
        if appVersion == getCurrentAppVersion() {
            Log.shared.add(.appUpdates, .info, "App is up to date! (\(getCurrentAppVersion()))")
        } else {
            Log.shared.add(.appUpdates, .info, "App is not up to date! (\(getCurrentAppVersion()))")
            updateApp()
        }
    }
    
    ///
    ///  Method to update the app
    ///
    ///  This function will clear old userDefaults and save the Current App Version
    ///
    ///
    ///  - Note: Add additional tasks which need to be performed with a new app version
    ///
    private func updateApp() {
        settings.clearUserDefaults()
        UserDefaults.standard.setValue(getCurrentAppVersion(), forKey: "CurrentAppVersion")
        Log.shared.add(.appUpdates, .info, "App has been updated (\(getCurrentAppVersion()))")
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
