//
//  RefreshRateViewModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct RefreshRateViewModel: View {
    
    // MARK: - @State Variables
    @State var refreshRate : Double = Double(SettingsAPI.shared.readFrequency())
    
    
    // MARK: - Methods
    func updateSlider() {
        SettingsAPI.shared.saveFrequency(frequency: Float(self.refreshRate))
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        // Update Sensor Interval
        CoreMotionAPI.shared.sensorUpdateInterval = (1 / self.refreshRate)
        
        return GeometryReader { g in
            VStack{
                Group{
                    Text("Refresh Rate")
                        .frame(width: g.size.width, height: CGFloat(50), alignment: .center)
                        .font(.title)
                        .foregroundColor(Color("HeaderTextColor"))
                        .background(Color("HeaderBackgroundColor"))
                    Spacer()
                    Text("Frequency: \(Int(self.refreshRate)) Hz")
                        .frame(width: g.size.width, height: CGFloat(50), alignment: .leading)
                }
                .font(.body)
                .foregroundColor(Color("StandardTextColor"))
                .background(Color("StandardBackgroundColor"))
                .cornerRadius(10)
                Spacer()
                Group {
                    HStack {
                        Text("1")
                            .frame(width: CGFloat(50), height: CGFloat(50), alignment: .center)
                            .background(Color("StandardBackgroundColor"))
                            .cornerRadius(CGFloat(10))
                        Slider(value: self.$refreshRate, in: 1...50, step: 1) { refresh in
                            self.updateSlider()
                        }
                        Text("50")
                            .frame(width: CGFloat(50), height: CGFloat(50), alignment: .center)
                            .background(Color("StandardBackgroundColor"))
                            .cornerRadius(CGFloat(10))
                    }
                    .frame(width: g.size.width, height: CGFloat(50), alignment: .center)
                    .font(.body)
                    .foregroundColor(Color("StandardTextColor"))
                }
            }.frame(width: g.size.width, height: 170)
        }
    }
}


// MARK: - Preview
#if DEBUG
struct RefreshRateViewModel_Previews: PreviewProvider {
    static var previews: some View {
        RefreshRateViewModel()
            .previewLayout(.sizeThatFits)
    }
}
#endif
