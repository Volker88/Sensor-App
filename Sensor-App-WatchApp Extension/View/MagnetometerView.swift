//
//  MagnetometerView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct MagnetometerView: View {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - @State / @ObservedObject
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency: Float = SettingsAPI.shared.fetchFrequency() // Default Frequency
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        // Start updating motion
        motionVM.motionUpdateStart()
    }
    
    func onDisappear() {
        CoreMotionAPI.shared.motionUpdateStop()
        motionVM.coreMotionArray.removeAll()
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return List {
            Text("X-Axis: \(self.motionVM.coreMotionArray.last?.magnetometerXAxis ?? 0.0, specifier: "%.5f") µT")
            Text("Y-Axis: \(self.motionVM.coreMotionArray.last?.magnetometerYAxis ?? 0.0, specifier: "%.5f") µT")
            Text("Z-Axis: \(self.motionVM.coreMotionArray.last?.magnetometerZAxis ?? 0.0, specifier: "%.5f") µT")
        }
        .navigationBarTitle("Magnetometer")
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
}


// MARK: - Preview
struct MagnetometerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MagnetometerView().previewDevice("Apple Watch Series 3 - 38mm")
            MagnetometerView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}