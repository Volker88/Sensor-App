//
//  GravityView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct GravityView: View {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - @State Variables
    @State var frequency: Float = SettingsAPI.shared.readFrequency() // Default Frequency
    @State var motionArray = [MotionModel]()
    @State var gravityXAxis = 0.0
    @State var gravityYAxis = 0.0
    @State var gravityZAxis = 0.0
    
    
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
            
            self.gravityXAxis = self.motionArray.first!.gravityXAxis
            self.gravityYAxis = self.motionArray.first!.gravityYAxis
            self.gravityZAxis = self.motionArray.first!.gravityZAxis
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
                                Text("X-Axis: \(self.gravityXAxis) g (9,81 m/s^2)")
                                    .frame(width: geometry.size.width - 10, height: CGFloat(50), alignment: .leading)
                                Spacer()
                                Text("Y-Axis: \(self.gravityYAxis) g (9,81 m/s^2)")
                                    .frame(width: geometry.size.width - 10, height: CGFloat(50), alignment: .leading)
                                Spacer()
                                Text("Z-Axis: \(self.gravityZAxis) g (9,81 m/s^2)")
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
                                        Text("X:\(String(format: "%.5f", self.motionArray[index.counter - 1].gravityXAxis))")
                                            .foregroundColor(Color("ListTextColor"))
                                        Spacer()
                                        Text("Y:\(String(format: "%.5f", self.motionArray[index.counter - 1].gravityYAxis))")
                                            .foregroundColor(Color("ListTextColor"))
                                        Spacer()
                                        Text("Z:\(String(format: "%.5f", self.motionArray[index.counter - 1].gravityZAxis))")
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
            .navigationBarTitle(Text("Gravity"), displayMode: .inline)
            .navigationBarHidden(true)
            .background(Color("ViewBackgroundColor").edgesIgnoringSafeArea(.all))
        }
        .navigationBarTitle("Gravity", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear { self.onAppear() }
        .onDisappear { self.onDisappear() }
    }
}


// MARK: - Preview
#if DEBUG
struct GravityView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GravityView().previewDevice("iPhone Xs")
            GravityView().previewDevice("iPhone Xs")
                .environment(\.colorScheme, .dark)
            //GravityView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //GravityView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //.environment(\.colorScheme, .dark)
        }
    }
}
#endif
