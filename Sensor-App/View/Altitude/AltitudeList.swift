//
//  AltitudeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AltitudeList: View {
    
    // MARK: - Initialize Classes
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM: CoreMotionViewModel
    
    
    // MARK: - Define Constants / Variables
    
    // MARK: - Methods
    
    // MARK: - Body - View
    var body: some View {
        
        // MARK: - Return View
        List(motionVM.altitudeArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "AltitudeList - ID")
                Spacer()
                Text("P:\(calculationAPI.calculatePressure(pressure: item.pressureValue, to: settings.fetchUserSettings().pressureSetting), specifier: "%.5f")", comment: "AltitudeList - P")
                Spacer()
                Text("A:\(calculationAPI.calculateHeight(height: item.relativeAltitudeValue, to: settings.fetchUserSettings().altitudeHeightSetting), specifier: "%.5f")", comment: "AltitudeList - A")
            }
            .font(.footnote)
        }
        .listStyle(PlainListStyle())
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 250, maxHeight: 250, alignment: .center)
    }
}


// MARK: - Preview
struct AltitudeList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            AltitudeList(motionVM: CoreMotionViewModel())
                .colorScheme(scheme)
                .previewLayout(.sizeThatFits)
        }
    }
}
