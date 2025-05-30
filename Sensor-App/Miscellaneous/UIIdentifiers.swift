//
//  UIIdentifiers.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 30.05.25.
//

import Foundation

enum UIIdentifiers {
    enum Sidebar {
        // Collection View
        static let collectionView = "Sidebar.list"

        // Navigation Buttons
        static let homeButton = "Sidebar.button.home"
        static let locationButton = "Sidebar.button.location"
        static let accelerationButton = "Sidebar.button.acceleration"
        static let gravityButton = "Sidebar.button.gravity"
        static let gyroscopeButton = "Sidebar.button.gyroscope"
        static let magnetometerButton = "Sidebar.button.magnetometer"
        static let attitudeButton = "Sidebar.button.attitude"
        static let altitudeButton = "Sidebar.button.altitude"
        static let settingsButton = "Sidebar.button.settings"
    }

    enum Toolbar {
        // Action Buttons
        static let playButton = "Toolbar.button.play"
        static let pauseButton = "Toolbar.button.pause"
        static let deleteButton = "Toolbar.button.delete"
    }

    enum RefreshRateView {
        // Slider
        static let refreshRateSlider = "RefreshRateView.slider"
    }

    // MARK: - Modules
    enum LocationView {
        // Navigation Button
        static let mapButton = "LocationView.button.map"

        // Action Button
        static let exportButton = "LocationView.button.export"

        // Disclosure Group
        static let latitudeRow = "LocationView.disclosureGroup.latitude"
        static let longitudeRow = "LocationView.disclosureGroup.longitude"
        static let altitudeRow = "LocationView.disclosureGroup.altitude"
        static let courseRow = "LocationView.disclosureGroup.course"
        static let speedRow = "LocationView.disclosureGroup.speed"
    }

    enum AccelerationView {
        // Navigation Button
        static let logButton = "AccelerationView.button.log"

        // Disclosure Group
        static let xAxisRow = "AccelerationView.disclosureGroup.xAxis"
        static let yAxisRow = "AccelerationView.disclosureGroup.yAxis"
        static let zAxisRow = "AccelerationView.disclosureGroup.zAxis"
    }

    enum AccelerationList {
        // Action Button
        static let exportButton = "AccelerationList.button.export"
    }

    enum GravityView {
        // Navigation Button
        static let logButton = "GravityView.button.log"

        // Disclosure Group
        static let xAxisRow = "GravityView.disclosureGroup.xAxis"
        static let yAxisRow = "GravityView.disclosureGroup.yAxis"
        static let zAxisRow = "GravityView.disclosureGroup.zAxis"
    }

    enum GravityList {
        // Action Button
        static let exportButton = "GravityList.button.export"
    }

    enum GyroscopeView {
        // Navigation Button
        static let logButton = "GyroscopeView.button.log"

        // Disclosure Group
        static let xAxisRow = "GyroscopeView.disclosureGroup.xAxis"
        static let yAxisRow = "GyroscopeView.disclosureGroup.yAxis"
        static let zAxisRow = "GyroscopeView.disclosureGroup.zAxis"
    }

    enum GyroscopeList {
        // Action Button
        static let exportButton = "GyroscopeList.button.export"
    }

    enum AltitudeView {
        // Navigation Button
        static let logButton = "AltitudeView.button.log"

        // Disclosure Group
        static let pressureRow = "AltitudeView.disclosureGroup.pressure"
        static let altitudeRow = "AltitudeView.disclosureGroup.altitude"
    }

    enum AltitudeList {
        // Action Button
        static let exportButton = "AltitudeList.button.export"
    }

    enum AttitudeView {
        // Navigation Button
        static let logButton = "AttitudeView.button.log"

        // Disclosure Group
        static let rollRow = "AttitudeView.disclosureGroup.roll"
        static let pitchRow = "AttitudeView.disclosureGroup.pitch"
        static let yawRow = "AttitudeView.disclosureGroup.yaw"
        static let headingRow = "AttitudeView.disclosureGroup.heading"
    }

    enum AttitudeList {
        // Action Button
        static let exportButton = "AttitudeList.button.export"
    }

    enum MagnetometerView {
        // Navigation Button
        static let logButton = "MagnetometerView.button.log"

        // Disclosure Group
        static let xAxisRow = "MagnetometerView.disclosureGroup.xAxis"
        static let yAxisRow = "MagnetometerView.disclosureGroup.yAxis"
        static let zAxisRow = "MagnetometerView.disclosureGroup.zAxis"
    }

    enum MagnetometerList {
        // Action Button
        static let exportButton = "MagnetometerList.button.export"
    }

    enum SettingScreen {
        // Collection View
        static let collectionView = "SettingScreen.list"

        // Picker
        static let speedPicker = "SettingScreen.picker.speed"
        static let accuracyPicker = "SettingScreen.picker.accuracy"
        static let mapTypePicker = "SettingScreen.picker.mapType"
        static let pressurePicker = "SettingScreen.picker.pressure"
        static let altitudePicker = "SettingScreen.picker.altitude"

        // Toggle
        static let compassToggle = "SettingScreen.toggle.compass"
        static let scaleToggle = "SettingScreen.toggle.scale"
        static let buildingsToggle = "SettingScreen.toggle.buildings"
        static let trafficToggle = "SettingScreen.toggle.traffic"
        static let rotateToggle = "SettingScreen.toggle.rotate"
        static let pitchToggle = "SettingScreen.toggle.pitch"
        static let scrollToggle = "SettingScreen.toggle.scroll"

        // Stepper
        static let zoomStepper = "SettingScreen.stepper.zoom"
        static let maxPointsStepper = "SettingScreen.stepper.maxPoints"

        // Slider
        static let zoomSlider = "SettingScreen.slider.zoom"
        static let maxPointsSlider = "SettingScreen.slider.maxPoints"

        // Action Button
        static let saveButton = "SettingScreen.button.save"
        static let discardButton = "SettingScreen.button.discard"
    }
}
