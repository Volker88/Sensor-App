//
//  RefreshRateView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct RefreshRateView: View {
    
    
    
    // MARK: - Initialize Classes
    let settings = SettingsAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    //@Binding var refreshRate: Double
    @ObservedObject var motionVM: CoreMotionViewModel
    
    
    
    // MARK: - Define Constants / Variables
    let show: String
    
    // MARK: - Methods
    func updateSlider() {
        // Save Sensor Settings
        var userSettings = settings.fetchUserSettings()
        userSettings.frequencySetting = motionVM.sensorUpdateInterval
        settings.saveUserSettings(userSettings: userSettings)
    }
    
    
    
    // MARK: - Body - View
    var body: some View {
        
        // MARK: - Return View
        if show == "header" {
            HStack {
                Text("\(NSLocalizedString("Frequency:", comment: "RefreshRateView - Frequency")) \(Double(motionVM.sensorUpdateInterval), specifier: "%.1f") Hz", comment: "RefreshRateView - Refresh Rate")
                Stepper("", value: $motionVM.sensorUpdateInterval, in: 1...10, step: 0.1)
            }
        } else if show == "slider" {
            HStack {
                Text("1", comment: "RefreshRateView - Label 1")
                
                Slider(value: $motionVM.sensorUpdateInterval, in: 1...10, step: 0.1) { _ in
                    updateSlider()
                }
                .accessibility(label: Text("Refresh Rate", comment: "RefreshRateView - Slider"))
                .accessibility(value: Text("\(motionVM.sensorUpdateInterval, specifier: "%.1f") per Second", comment: "RefreshRateView - Value"))
                .accessibility(identifier: "Frequency Slider")
                Text("10", comment: "RefreshRateView - Label 10")
                
            }
        }
    }
}


// MARK: - Preview
struct RefreshRateView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            Group {
                RefreshRateView(motionVM: CoreMotionViewModel(), show: "header")
                RefreshRateView(motionVM: CoreMotionViewModel(), show: "slider")
            }
            .colorScheme(scheme)
            .previewLayout(.sizeThatFits)
        }
    }
}



