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
    
    // MARK: - @State Variables
    @State var refreshRate: Double = SettingsAPI.shared.fetchUserSettings().frequencySetting
    var updateSensorInterval: () -> Void
    
    
    // MARK: - Methods
    func updateSlider() {
        // Save Sensor Settings
        var settings = SettingsAPI.shared.fetchUserSettings()
        settings.frequencySetting = self.refreshRate
        SettingsAPI.shared.saveUserSettings(userSettings: settings)
        
        // Update Sensor Interval
        
        updateSensorInterval()
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return GeometryReader { g in
            VStack{
                Group{
                    Text("Refresh Rate")
                        .modifier(ButtonTitleModifier())
                    Text("Frequency: \(Int(self.refreshRate)) Hz")
                        .modifier(ButtonModifier())
                }
                .frame(height: 50)
                

                    HStack {
                        Text("1")
                            .modifier(RefreshRateLimitLabel())
                        Slider(value: self.$refreshRate, in: 1...50, step: 1) { refresh in
                            self.updateSlider()
                        }
                        .accessibility(identifier: "Frequency Slider")
                        Text("50")
                            .modifier(RefreshRateLimitLabel())
                }
                .frame(width: g.size.width - 10, height: 50)
                    .offset(x: -5)
            }
            .frame(height: 170)
        }
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

