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
        List(motionVM.coreMotionArray.reversed(), id: \.counter) { index in
            HStack{
                Text("ID:\(motionVM.coreMotionArray[index.counter - 1].counter)", comment: "MotionListView - ID")
                Spacer()
                Text("R:\(motionVM.coreMotionArray[index.counter - 1].attitudeRoll * 180 / .pi, specifier: "%.3f")", comment: "MotionListView - R")
                Spacer()
                Text("P:\(motionVM.coreMotionArray[index.counter - 1].attitudePitch * 180 / .pi, specifier: "%.3f")", comment: "MotionListView - P")
                Spacer()
                Text("Y:\(motionVM.coreMotionArray[index.counter - 1].attitudeYaw * 180 / .pi, specifier: "%.3f")" , comment: "MotionListView - Yield")
                Spacer()
                Text("H:\(motionVM.coreMotionArray[index.counter - 1].attitudeHeading, specifier: "%.3f")", comment: "MotionListView - H")
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
