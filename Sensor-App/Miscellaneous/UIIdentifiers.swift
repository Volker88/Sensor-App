//
//  UIIdentifiers.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 30.05.25.
//

import Foundation

enum UIIdentifiers {

    enum ContentView {
        static let printerButton = "ContentView.button.printer"
        static let filamentButton = "ContentView.button.filament"
        static let filamentInsightsButton = "ContentView.button.filamentInsights"
        static let settingsButton = "ContentView.button.settings"
    }

    // MARK: - Printer
    enum PrinterInventoryScreen {
        static let collectionView = "PrinterInventoryScreen.list"
        static let collectionViewRow = "PrinterInventoryScreen.list.rows"
        static let printerNameLabel = "PrinterInventoryScreen.label.printerName"

        static let addButton = "PrinterInventoryScreen.button.add"
        static let editButton = "PrinterInventoryScreen.button.edit"
        static let deleteButton = "PrinterInventoryScreen.button.delete"

    }

    enum AddEditPrinterScreen {
        static let form = "AddEditPrinterScreen.form"

        static let nameTextField = "AddEditPrinterScreen.textfield.name"
        static let brandTextField = "AddEditPrinterScreen.textfield.brand"
        static let modelTextField = "AddEditPrinterScreen.textfield.model"
        static let costTextField = "AddEditPrinterScreen.textfield.cost"
        static let favoriteToggle = "AddEditPrinterScreen.toggle.favorite"

        static let saveButton = "AddEditPrinterScreen.button.save"
        static let cancelButton = "AddEditPrinterScreen.button.cancel"
    }

    // MARK: - Settings
    enum SettingsScreen {
        static let collectionView = "SettingsScreen.list"
        static let materialCollection = "SettingsScreen.list.materials"

        static let addButton = "SettingsScreen.button.add"
        static let editButton = "SettingsScreen.button.edit"
        static let deleteButton = "SettingsScreen.button.delete"
    }

    enum AddEditFilamentMaterialScreen {
        static let form = "AddEditFilamentMaterialScreen.form"

        static let nameTextField = "AddEditFilamentMaterialScreen.textfield.name"

        static let saveButton = "AddEditFilamentMaterialScreen.button.save"
        static let cancelButton = "AddEditFilamentMaterialScreen.button.cancel"
    }

    // MARK: - Filament
    enum FilamentScreen {
        static let inventoryButton = "FilamentScreen.button.inventory"
        static let insightsButton = "FilamentScreen.button.insights"
    }

    enum FilamentInventoryScreen {
        static let addButton = "FilamentInventoryScreen.button.add"
    }

    enum FilamentInventoryTableView {
        static let collectionView = "FilamentInventoryTableView.list"
    }

    enum FilamentDetailsScreen {
        static let addUsageButton = "FilamentDetailsScreen.button.addUsage"
        static let addCalibrationButton = "FilamentDetailsScreen.button.addCalibration"
        static let addDryingButton = "FilamentDetailsScreen.button.addDrying"

        static let menuButton = "FilamentDetailsScreen.button.menu"
    }

    enum AddEditFilamentScreen {
        static let form = "AddEditFilamentScreen.form"

        static let uniqueIdTextField = "AddEditFilamentScreen.textfield.uniqueId"
        static let brandTextField = "AddEditFilamentScreen.textfield.brand"
        static let materialPicker = "AddEditFilamentScreen.picker.material"
        static let otherMaterialTextField = "AddEditFilamentScreen.textfield.otherMaterial"
        static let diameterTextField = "AddEditFilamentScreen.textfield.diameter"
        static let grossWeightTextField = "AddEditFilamentScreen.textfield.grossWeight"
        static let netWeightTextField = "AddEditFilamentScreen.textfield.netWeight"
        static let costTextField = "AddEditFilamentScreen.textfield.cost"
        static let filamentOpenedToggle = "AddEditFilamentScreen.toggle.filamentOpened"
        static let favoriteToggle = "AddEditFilamentScreen.toggle.favorite"

        static let saveButton = "AddEditFilamentScreen.button.save"
        static let cancelButton = "AddEditFilamentScreen.button.cancel"
    }
    enum FilamentDetailsOverviewScreen {
        static let collection = "FilamentDetailsOverviewScreen.collection"

        static let remainingWeightLabel = "FilamentDetailsOverviewScreen.label.remainingWeight"
    }

    enum FilamentDetailsOverviewView {
        static let overviewButton = "FilamentDetailsOverviewView.button.overview"
    }

    enum AddEditFilamentCalibrationScreen {
        static let form = "AddEditFilamentCalibrationScreen.form"

        static let maxVolumSpeedTextField = "AddEditFilamentCalibrationScreen.textfield.maxVolumSpeed"
        static let paTextField = "AddEditFilamentCalibrationScreen.textfield.pa"
        static let flowRatioTextField = "AddEditFilamentCalibrationScreen.textfield.flowRatio"

        static let saveButton = "AddEditFilamentCalibrationScreen.button.save"
        static let cancelButton = "AddEditFilamentCalibrationScreen.button.cancel"
    }

    enum FilamentCalibrationScrollView {
        static let filamentCalibrationButton = "FilamentCalibrationScrollView.button.filamentCalibration"
    }

    enum FilamentCalibrationScreen {
        static let parameterList = "FilamentCalibrationScreen.parameterList"
    }

    enum AddEditFilamentMeasureScreen {
        static let form = "AddEditFilamentMeasureScreen.form"

        static let grossWeightTextField = "AddEditFilamentMeasureScreen.textfield.grossWeight"

        static let saveButton = "AddEditFilamentMeasureScreen.button.save"
        static let cancelButton = "AddEditFilamentMeasureScreen.button.cancel"
    }

    enum FilamentMeasureScreen {
        static let measureList = "FilamentMeasureScreen.measureList"
    }

    enum FilamentMeasureScrollView {
        static let filamentMeasureButton = "FilamentMeasureScrollView.button.filamentMeasure"
    }

    enum AddEditFilamentDryingScreen {
        static let form = "AddEditFilamentDryingScreen.form"

        static let temperatureTextField = "AddEditFilamentDryingScreen.textfield.temperature"
        static let humidityTextField = "AddEditFilamentDryingScreen.textfield.humidity"
        static let durationTextField = "AddEditFilamentDryingScreen.textfield.duration"

        static let saveButton = "AddEditFilamentDryingScreen.button.save"
        static let cancelButton = "AddEditFilamentDryingScreen.button.cancel"
    }

    enum FilamentDryingScreen {
        static let dryingList = "FilamentDryingScreen.dryingList"
    }

    enum FilamentDryingScrollView {
        static let filamentDryingButton = "FilamentDryingScrollView.button.filamentDrying"
    }
}
