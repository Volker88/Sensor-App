//
//  AttitudeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AttitudeList: View {
    
    // MARK: - Initialize Classes
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM: CoreMotionViewModel
    
    
    // MARK: - Define Constants / Variables
    
    // MARK: - Methods
    
    // MARK: - Body - View
    var body: some View {
        
        // MARK: - Return View
        List(motionVM.coreMotionArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "AttitudeList - ID")
                Spacer()
                Text("R:\(item.attitudeRoll * 180 / .pi, specifier: "%.3f")", comment: "AttitudeList - R")
                Spacer()
                Text("P:\(item.attitudePitch * 180 / .pi, specifier: "%.3f")", comment: "AttitudeList - P")
                Spacer()
                Text("Y:\(item.attitudeYaw * 180 / .pi, specifier: "%.3f")" , comment: "AttitudeList - Yield")
                Spacer()
                Text("H:\(item.attitudeHeading, specifier: "%.3f")", comment: "AttitudeList - H")
            }
            .font(.footnote)
        }
        .listStyle(PlainListStyle())
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 250, maxHeight: 250, alignment: .center)
    }
}


// MARK: - Preview
struct AttitudeList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            AttitudeList(motionVM: CoreMotionViewModel())
                .colorScheme(scheme)
                .previewLayout(.sizeThatFits)
        }
    }
}
