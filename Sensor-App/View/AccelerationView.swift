//
//  AccelerationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AccelerationView: View {
    
    // MARK: - Initialize Classes
    

    // MARK: - @State Variables
    @State var frequency: Float = SettingsAPI.shared.readFrequency() // Default Frequency
    @State var motionArray = [MotionModel]()
    @State var accelerationXAxis = 0.0
    @State var accelerationYAxis = 0.0
    @State var accelerationZAxis = 0.0
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    func motionManagerStart() {
        // Start Motion
        CoreMotionAPI.shared.motionStartMethod()
        
        // Update Labels
        CoreMotionAPI.shared.motionCompletionHandler = { motionManager in
            // Check if Array is empty
            if motionManager.isEmpty { return }
            
            // Make Array available globally
            self.motionArray = motionManager
            
            self.accelerationXAxis = self.motionArray.first!.accelerationXAxis
            self.accelerationYAxis = self.motionArray.first!.accelerationYAxis
            self.accelerationZAxis = self.motionArray.first!.accelerationZAxis
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
                                Text("X-Axis: \(self.accelerationXAxis) m/s^2")
                                    .frame(width: geometry.size.width - 10, height: CGFloat(50), alignment: .leading)
                                Spacer()
                                Text("Y-Axis: \(self.accelerationYAxis) m/s^2")
                                    .frame(width: geometry.size.width - 10, height: CGFloat(50), alignment: .leading)
                                Spacer()
                                Text("Z-Axis: \(self.accelerationZAxis) m/s^2")
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
                                        Text("X:\(String(format: "%.5f", self.motionArray[index.counter - 1].accelerationXAxis))")
                                            .foregroundColor(Color("ListTextColor"))
                                        Spacer()
                                        Text("Y:\(String(format: "%.5f", self.motionArray[index.counter - 1].accelerationYAxis))")
                                            .foregroundColor(Color("ListTextColor"))
                                        Spacer()
                                        Text("Z:\(String(format: "%.5f", self.motionArray[index.counter - 1].accelerationZAxis))")
                                            .foregroundColor(Color("ListTextColor"))
                                    }
                                    .font(.footnote)
                                    //.background(Color("ListBackgroundColor"))
                                }
                                .frame(width: geometry.size.width, height: 200, alignment: .center)
                                Spacer()
                            }
                            Spacer()
                            
                            
                            // MARK: - RefreshRateViewModel()
                            RefreshRateViewModel()
                                .frame(width: geometry.size.width - 10, height: CGFloat(165))
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height - 50 + geometry.safeAreaInsets.bottom)
                    
                    
                    // MARK: - MotionToolBarViewModel()
                    MotionToolBarViewModel()
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarTitle(Text("Acceleration"), displayMode: .inline)
            .navigationBarHidden(true)
            .background(Color("ViewBackgroundColor").edgesIgnoringSafeArea(.all))
        }
        .navigationBarTitle("Acceleration", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear { self.onAppear() }
        .onDisappear { self.onDisappear() }
    }
}


// MARK: - Preview
#if DEBUG
struct AccelerationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccelerationView().previewDevice("iPhone Xs")
            AccelerationView().previewDevice("iPhone Xs")
                .environment(\.colorScheme, .dark)
            //AccelerationView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //AccelerationView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //.environment(\.colorScheme, .dark)
        }
    }
}
#endif
