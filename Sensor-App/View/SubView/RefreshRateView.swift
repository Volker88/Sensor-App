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
    @State var refreshRate : Double = Double(SettingsAPI.shared.fetchFrequency())
    
    
    // MARK: - Methods
    func updateSlider() {
        
        // Save Sensor Settings
        SettingsAPI.shared.saveFrequency(frequency: Float(self.refreshRate))
        
        // Update Sensor Interval
        CoreMotionAPI.shared.sensorUpdateInterval = self.refreshRate
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
                .frame(height: 50, alignment: .center)
                Group {
                    HStack {
                        Text("1")
                            .modifier(RefreshRateLimitLabel())
                        Slider(value: self.$refreshRate, in: 1...50, step: 1) { refresh in
                            self.updateSlider()
                        }
                        Text("50")
                            .modifier(RefreshRateLimitLabel())
                    }
                }
                .frame(width: g.size.width - 10, height: 50, alignment: .center)
            }
            .frame(height: 170)
        }
    }
}


// MARK: - Preview
struct RefreshRateView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshRateView()
            .previewLayout(.sizeThatFits)
    }
}

