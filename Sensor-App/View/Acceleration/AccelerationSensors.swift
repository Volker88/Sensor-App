//
//  AccelerationSensors.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AccelerationSensors: View {
    
    // MARK: - Initialize Classes
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @StateObject var motionVM = CoreMotionViewModel()
    
    // Show Graph
    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
//        return List {
//            Section(header: Text("Acceleration", comment: "AccelerationView - Section Header")) {
//                DisclosureGroup(
//                    isExpanded: $showXAxis,
//                    content: {
//                        LineGraphSubView(motionVM: motionVM, showGraph: .accelerationXAxis)
//                            .frame(height: 100, alignment: .leading)
//                    },
//                    label: {
        Text("\(motionVM.coreMotionArray.last?.accelerationXAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - X-Axis")
            
//                    })
//                    .disclosureGroupModifier(accessibility: "Toggle X-Axis Graph")
//
//                DisclosureGroup(
//                    isExpanded: $showYAxis,
//                    content: {
//                        LineGraphSubView(motionVM: motionVM, showGraph: .accelerationXAxis)
//                            .frame(height: 100, alignment: .leading)
//                    },
//                    label: {
//                        Text("Y-Axis: \(motionVM.coreMotionArray.last?.accelerationYAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - Y-Axis")
//                    })
//                    .disclosureGroupModifier(accessibility: "Toggle Y-Axis Graph")
//
//                DisclosureGroup(
//                    isExpanded: $showZAxis,
//                    content: {
//                        LineGraphSubView(motionVM: motionVM, showGraph: .accelerationZAxis)
//                            .frame(height: 100, alignment: .leading)
//                    },
//                    label: {
//                        Text("Z-Axis: \(motionVM.coreMotionArray.last?.accelerationZAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - Z-Axis")
//                    })
//                    .disclosureGroupModifier(accessibility: "Toggle Z-Axis Graph")
//            }
        }
//        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 250, maxHeight: 250, alignment: .center)
//    }
}

// MARK: - Preview
//struct AccelerationSensors_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
//            AccelerationSensors(motionVM: <#Binding<CoreMotionViewModel>#>)
//                .colorScheme(scheme)
//                .previewLayout(.sizeThatFits)
//        }
//    }
//}
