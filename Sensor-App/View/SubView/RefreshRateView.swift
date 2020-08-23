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
    @State var refreshRate: Double = 1.0
    var updateSensorInterval: () -> Void
    
    
    // MARK: - Methods
    func updateSlider() {
        // Save Sensor Settings
        var userSettings = settings.fetchUserSettings()
        userSettings.frequencySetting = self.refreshRate
        settings.saveUserSettings(userSettings: userSettings)
        
        // Update Sensor Interval
        updateSensorInterval()
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return GeometryReader { g in
            VStack{
                Group{
                    Text("Refresh Rate", comment: "RefreshRateView - Refresh Rate")
                        .buttonTitleModifier()
                        .accessibility(addTraits: .isHeader)
                    Text("\(NSLocalizedString("Frequency:", comment: "RefreshRateView - Frequency")) \(Int(self.refreshRate)) Hz", comment: "RefreshRateView - Refresh Rate")
                        .buttonModifier()
                }
                .frame(height: 50)
                
                HStack {
                    Text("1", comment: "RefreshRateView - Label 1")
                        .refreshRateLimitLabelModifier()
                    Slider(value: self.$refreshRate, in: 1...50, step: 1) { refresh in
                        self.updateSlider()
                    }
                    .hoverEffect()
                    .accessibility(label: Text("Refresh Rate", comment: "RefreshRateView - Slider"))
                    .accessibility(value: Text("\(self.refreshRate, specifier: "%.0f") per Second", comment: "RefreshRateView - Value"))
                    .accessibility(identifier: "Frequency Slider")
                    Text("50", comment: "RefreshRateView - Label 50")
                        .refreshRateLimitLabelModifier()
                }
                .frame(width: g.size.width - 10, height: 50)
                .offset(x: -5)
            }
            .frame(height: 170)
        }
        .onAppear(perform: { self.refreshRate = self.settings.fetchUserSettings().frequencySetting })
        .frame(alignment: .center)
    }
}


// MARK: - Preview
struct RefreshRateView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            RefreshRateView(updateSensorInterval: { })
                .colorScheme(scheme)
                .previewLayout(.fixed(width: 400, height: 170))
        }
    }
}


#warning("Rename View")
// MARK: - Struct
struct RefreshRateView2: View {
    
   
    
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
            Text("\(NSLocalizedString("Frequency:", comment: "RefreshRateView - Frequency")) \(Double(motionVM.sensorUpdateInterval), specifier: "%.1f") Hz", comment: "RefreshRateView - Refresh Rate")
        } else if show == "slider" {
            HStack {
                Text("1", comment: "RefreshRateView - Label 1")
                
                Slider(value: $motionVM.sensorUpdateInterval, in: 1...10, step: 0.1) { _ in
                   self.updateSlider()
                }
                .hoverEffect()
                .accessibility(label: Text("Refresh Rate", comment: "RefreshRateView - Slider"))
                .accessibility(value: Text("\(motionVM.sensorUpdateInterval, specifier: "%.1f") per Second", comment: "RefreshRateView - Value"))
                .accessibility(identifier: "Frequency Slider")
                Text("10", comment: "RefreshRateView - Label 50")
                
            }
        }
    }
}

