//
//  AppUpdates.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import OSLog
import SwiftUI

@Observable
public class AppUpdates {

    public init() {}

    public var showReleaseNotes = false

    public let settings = SettingsManager()

    /// Call this function to check if the app version is up to date
    public func checkForUpdate() {
        let appVersion = UserDefaults.standard.string(forKey: "CurrentAppVersion")

        if appVersion == getCurrentAppVersion() {
            Logger.appUpdate.debug("App is up to date! (\(self.getCurrentAppVersion()))")
        } else {
            Logger.appUpdate.debug("App is not up to date! (\(self.getCurrentAppVersion()))")
            if appVersion == nil {
                Logger.appUpdate.debug("App is opened the first time")
            } else {
                showReleaseNotes = settings.fetchUserSettings().showReleaseNotes
                Logger.appUpdate.debug("Show Release Notes")
            }
            updateApp()
        }
    }

    ///  Method to update the app
    ///
    ///  This function will clear old userDefaults and save the Current App Version
    ///  - Note: Add additional tasks which need to be performed with a new app version
    private func updateApp() {
        settings.clearUserDefaults()
        UserDefaults.standard.setValue(getCurrentAppVersion(), forKey: "CurrentAppVersion")
        Logger.appUpdate.debug("App has been updated (\(self.getCurrentAppVersion()))")
    }

    ///  Call this method to get the current app version number
    ///
    ///  - Returns: App Version
    private func getCurrentAppVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        let version = (appVersion as! String)  // swiftlint:disable:this force_cast

        return version
    }
}
