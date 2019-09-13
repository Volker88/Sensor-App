//
//  AttitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AttitudeView: View {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - @State Variables
    @State var frequency: Float = SettingsAPI.shared.readFrequency() // Default Frequency
    @State var motionArray = [MotionModel]()
    @State var attitudeRoll = 0.0
    @State var attitudePitch = 0.0
    @State var attitudeYaw = 0.0
    @State var attitudeHeading = 0.0
    
    
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
            
            self.attitudeRoll = self.motionArray.first!.attitudeRoll
            self.attitudePitch = self.motionArray.first!.attitudePitch
            self.attitudeYaw = self.motionArray.first!.attitudeYaw
            self.attitudeHeading = self.motionArray.first!.attitudeHeading
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
                                Text("Roll: \(self.attitudeRoll * 180 / .pi) °")
                                    .frame(width: geometry.size.width - 10, height: CGFloat(50), alignment: .leading)
                                Spacer()
                                Text("Pitch: \(self.attitudePitch * 180 / .pi) °")
                                    .frame(width: geometry.size.width - 10, height: CGFloat(50), alignment: .leading)
                                Spacer()
                                Text("Yaw: \(self.attitudeYaw * 180 / .pi) °")
                                    .frame(width: geometry.size.width - 10, height: CGFloat(50), alignment: .leading)
                                Spacer()
                                Text("Heading: \(self.attitudeHeading * 180 / .pi) °")
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
                                        Text("R:\(String(format: "%.5f", self.motionArray[index.counter - 1].attitudeRoll))")
                                            .foregroundColor(Color("ListTextColor"))
                                        Spacer()
                                        Text("P:\(String(format: "%.5f", self.motionArray[index.counter - 1].attitudePitch))")
                                            .foregroundColor(Color("ListTextColor"))
                                        Spacer()
                                        Text("Y:\(String(format: "%.5f", self.motionArray[index.counter - 1].attitudeYaw))")
                                            .foregroundColor(Color("ListTextColor"))
                                        Spacer()
                                        Text("H:\(String(format: "%.5f", self.motionArray[index.counter - 1].attitudeHeading))")
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
            .navigationBarTitle(Text("Attitude"), displayMode: .inline)
            .navigationBarHidden(true)
            .background(Color("ViewBackgroundColor").edgesIgnoringSafeArea(.all))
        }
        .navigationBarTitle("Attitude", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear { self.onAppear() }
        .onDisappear { self.onDisappear() }
    }
}


// MARK: - Preview
#if DEBUG
struct AttitudeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AttitudeView().previewDevice("iPhone Xs")
            AttitudeView().previewDevice("iPhone Xs")
                .environment(\.colorScheme, .dark)
            //AttitudeView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //AttitudeView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //.environment(\.colorScheme, .dark)
        }
    }
}
#endif
