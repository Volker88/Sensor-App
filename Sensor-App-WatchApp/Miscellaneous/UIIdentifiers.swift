//
//  UIIdentifiers.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 31.05.25.
//

import Foundation

enum UIIdentifiers {
    enum ContentView {
        // Collection View
        static let collectionView = "ContentView.list"

        // Navigation Buttons
        static let locationButton = "ContentView.button.location"
        static let accelerationButton = "ContentView.button.acceleration"
        static let settingsButton = "ContentView.button.settings"
    }

    // Same identifier values as the iOS `CustomControlsView` so UI tests can share them.
    enum SensorControls {
        static let playButton = "CustomControlsView.Button.Play"
        static let pauseButton = "CustomControlsView.Button.Pause"
        static let deleteButton = "CustomControlsView.Button.Delete"
        static let recordButton = "CustomControlsView.Button.Record"
    }
}
