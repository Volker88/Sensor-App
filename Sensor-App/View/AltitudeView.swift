//
//  AltitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AltitudeView: View {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - @State Variables
    @State var frequency: Float = SettingsAPI.shared.readFrequency() // Default Frequency
    @State var motionArray = [AltitudeModel]()
    @State var pressureValue = 0.0
    @State var relativeAltitudeValue = 0.0

    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    func motionManagerStart() {
        // Start Motion
        CoreMotionAPI.shared.motionStartMethod()
        
        // Update Labels
        CoreMotionAPI.shared.altitudeCompletionHandler = { altitudeManager in
            // Check if Array is empty
            if altitudeManager.isEmpty { return }
            
            // Make Array available globally
            self.motionArray = altitudeManager
            
            let convertedValues = CalculationAPI.shared.convertAltitudeData(pressure: self.motionArray.first!.pressureValue, height: self.motionArray.first!.relativeAltitudeValue)
            
            self.pressureValue = convertedValues.convertedPressure
            self.relativeAltitudeValue = convertedValues.convertedHeight
        }
    }
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        CoreMotionAPI.shared.clearMotionArray { }
        motionManagerStart()
    }
    
    func onDisappear() {
        CoreLocationAPI.shared.stopGPS()
        CoreMotionAPI.shared.motionStopMethod()
        CoreMotionAPI.shared.clearMotionArray {
        }
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return NavigationView{
            GeometryReader { geometry in
                VStack{
                    ScrollView(.vertical) {
                        Spacer()
                        VStack{
                            Group{
                                Text("Pressure: \(self.pressureValue) \(SettingsAPI.shared.readPressureSetting())")
                                    .frame(width: geometry.size.width - 10, height: CGFloat(50), alignment: .leading)
                                Spacer()
                                Text("Altitude change: \(self.relativeAltitudeValue) \(SettingsAPI.shared.readHeightSetting())")
                                    .frame(width: geometry.size.width - 10, height: CGFloat(50), alignment: .leading)
                            }
                            .font(.body)
                            .foregroundColor(Color("StandardTextColor"))
                            .background(Color("StandardBackgroundColor"))
                            .cornerRadius(10)
                            
                            // MARK: - List
                            VStack{
                                List(self.motionArray.reversed(), id: \.counter) { index in
                                    HStack{
                                        Text("ID:\(self.motionArray[index.counter - 1].counter)")
                                            .foregroundColor(Color("ListTextColor"))
                                        Spacer()
                                        Text("P.:\(String(format: "%.5f", self.motionArray[index.counter - 1].pressureValue))")
                                            .foregroundColor(Color("ListTextColor"))
                                        Spacer()
                                        Text("A.:\(String(format: "%.5f", self.motionArray[index.counter - 1].relativeAltitudeValue))")
                                            .foregroundColor(Color("ListTextColor"))
                                    }
                                    .font(.footnote)
                                    //.background(Color("ListBackgroundColor"))
                                }
                                .frame(width: geometry.size.width, height: 200, alignment: .center)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height - 50 + geometry.safeAreaInsets.bottom)
                    
                    
                    // MARK: - MotionToolBarViewModel()
                    MotionToolBarViewModel()
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarTitle(Text("Altitude"), displayMode: .inline)
            .navigationBarHidden(true)
            .background(Color("ViewBackgroundColor").edgesIgnoringSafeArea(.all))
        }
        .navigationBarTitle("Altitude", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear { self.onAppear() }
        .onDisappear { self.onDisappear() }
    }
}


// MARK: - Preview
#if DEBUG
struct AltitudeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AltitudeView().previewDevice("iPhone Xs")
            AltitudeView().previewDevice("iPhone Xs")
                .environment(\.colorScheme, .dark)
            //AltitudeView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //AltitudeView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //.environment(\.colorScheme, .dark)
        }
    }
}
#endif
