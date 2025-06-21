//
//  UIIdentifiers.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 30.05.25.
//

import Foundation

enum UIIdentifiers {

    enum ContentView {
        // Tabs
        static let positionTab = "ContentView.Tab.Button.Position"
        static let locationTab = "ContentView.Tab.Button.location"
        static let altitudeTab = "ContentView.Tab.Button.Altitude"

        static let motionTab = "ContentView.Tab.Button.Motion"
        static let accelerationTab = "ContentView.Tab.Button.Acceleration"
        static let gravityTab = "ContentView.Tab.Button.Gravity"
        static let gyroscopeTab = "ContentView.Tab.Button.Gyroscope"
        static let attitudeTab = "ContentView.Tab.Button.Attitude"

        static let magnetometerTab = "ContentView.Tab.Button.Magnetometer"
        static let settingsTab = "ContentView.Tab.Button.Settings"
    }

    enum PositionScreen {
        static let locationButton = "PositionScreen.Grid.Button.Location"
        static let altitudeButton = "PositionScreen.Grid.Button.Altitude"
    }

    enum MotionScreen {
        static let accelerationButton = "MotionScreen.Grid.Button.Acceleration"
        static let gravityButton = "MotionScreen.Grid.Button.Gravity"
        static let gyroscopeButton = "MotionScreen.Grid.Button.Gyroscope"
        static let attitudeButton = "MotionScreen.Grid.Button.Attitude"
    }

    enum CustomControlsView {
        static let expandButton = "CustomControlsView.Button.Expand"
        static let playButton = "CustomControlsView.Button.Play"
        static let pauseButton = "CustomControlsView.Button.Pause"
        static let deleteButton = "CustomControlsView.Button.Delete"
    }

    enum RefreshRateView {
        // Slider
        static let refreshRateSlider = "RefreshRateView.Slider"
    }

    // MARK: - Modules
    enum LocationView {
        // Navigation Button
        static let mapButton = "LocationView.Button.Map"

        // Action Button
        static let exportButton = "LocationView.Button.Export"

        // Disclosure Group
        static let latitudeRow = "LocationView.DisclosureGroup.Latitude"
        static let longitudeRow = "LocationView.DisclosureGroup.Longitude"
        static let altitudeRow = "LocationView.DisclosureGroup.Altitude"
        static let courseRow = "LocationView.DisclosureGroup.Course"
        static let speedRow = "LocationView.DisclosureGroup.Speed"
    }

    enum AccelerationView {
        // Navigation Button
        static let logButton = "AccelerationView.Button.Log"

        // Disclosure Group
        static let xAxisRow = "AccelerationView.DisclosureGroup.xAxis"
        static let yAxisRow = "AccelerationView.DisclosureGroup.yAxis"
        static let zAxisRow = "AccelerationView.DisclosureGroup.zAxis"
    }

    enum AccelerationList {
        // Action Button
        static let exportButton = "AccelerationList.Button.Export"
    }

    enum GravityView {
        // Navigation Button
        static let logButton = "GravityView.Button.Log"

        // Disclosure Group
        static let xAxisRow = "GravityView.DisclosureGroup.xAxis"
        static let yAxisRow = "GravityView.DisclosureGroup.yAxis"
        static let zAxisRow = "GravityView.DisclosureGroup.zAxis"
    }

    enum GravityList {
        // Action Button
        static let exportButton = "GravityList.Button.Export"
    }

    enum GyroscopeView {
        // Navigation Button
        static let logButton = "GyroscopeView.Button.Log"

        // Disclosure Group
        static let xAxisRow = "GyroscopeView.DisclosureGroup.xAxis"
        static let yAxisRow = "GyroscopeView.DisclosureGroup.yAxis"
        static let zAxisRow = "GyroscopeView.DisclosureGroup.zAxis"
    }

    enum GyroscopeList {
        // Action Button
        static let exportButton = "GyroscopeList.Button.Export"
    }

    enum AltitudeView {
        // Navigation Button
        static let logButton = "AltitudeView.Button.Log"

        // Disclosure Group
        static let pressureRow = "AltitudeView.DisclosureGroup.Pressure"
        static let altitudeRow = "AltitudeView.DisclosureGroup.Altitude"
    }

    enum AltitudeList {
        // Action Button
        static let exportButton = "AltitudeList.Button.Export"
    }

    enum AttitudeView {
        // Navigation Button
        static let logButton = "AttitudeView.Button.Log"

        // Disclosure Group
        static let rollRow = "AttitudeView.DisclosureGroup.Roll"
        static let pitchRow = "AttitudeView.DisclosureGroup.Pitch"
        static let yawRow = "AttitudeView.DisclosureGroup.Yaw"
        static let headingRow = "AttitudeView.DisclosureGroup.Heading"
    }

    enum AttitudeList {
        // Action Button
        static let exportButton = "AttitudeList.Button.Export"
    }

    enum MagnetometerView {
        // Navigation Button
        static let logButton = "MagnetometerView.Button.Log"

        // Disclosure Group
        static let xAxisRow = "MagnetometerView.DisclosureGroup.xAxis"
        static let yAxisRow = "MagnetometerView.DisclosureGroup.yAxis"
        static let zAxisRow = "MagnetometerView.DisclosureGroup.zAxis"
    }

    enum MagnetometerList {
        // Action Button
        static let exportButton = "MagnetometerList.Button.Export"
    }

    enum SettingScreen {
        // Collection View
        static let collectionView = "SettingScreen.List"

        // Section
        static let locationHeader = "SettingScreen.Header.Location"
        static let mapHeader = "SettingScreen.Header.Map"
        static let altitudeHeader = "SettingScreen.Header.Altitude"
        static let graphHeader = "SettingScreen.Header.Graph"

        // Picker
        static let speedPicker = "SettingScreen.Picker.Speed"
        static let accuracyPicker = "SettingScreen.Picker.Accuracy"
        static let mapTypePicker = "SettingScreen.Picker.MapType"
        static let pressurePicker = "SettingScreen.Picker.Pressure"
        static let altitudePicker = "SettingScreen.Picker.Altitude"

        // Toggle
        static let compassToggle = "SettingScreen.Toggle.Compass"
        static let scaleToggle = "SettingScreen.Toggle.Scale"
        static let buildingsToggle = "SettingScreen.Toggle.Buildings"
        static let trafficToggle = "SettingScreen.Toggle.Traffic"
        static let rotateToggle = "SettingScreen.Toggle.Rotate"
        static let pitchToggle = "SettingScreen.Toggle.Pitch"
        static let scrollToggle = "SettingScreen.Toggle.Scroll"

        // Stepper
        static let zoomStepper = "SettingScreen.Stepper.Zoom"
        static let maxPointsStepper = "SettingScreen.Stepper.MaxPoints"

        // Slider
        static let zoomSlider = "SettingScreen.Slider.Zoom"
        static let maxPointsSlider = "SettingScreen.Slider.MaxPoints"

        // Action Button
        static let saveButton = "SettingScreen.Button.Save"
        static let discardButton = "SettingScreen.Button.Discard"
    }
}
