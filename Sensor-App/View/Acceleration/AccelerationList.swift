//
//  AccelerationList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AccelerationList: View {
    
    // MARK: - Initialize Classes
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM: CoreMotionViewModel
    
    
    // MARK: - Define Constants / Variables
    
    // MARK: - Methods
    
    // MARK: - Body - View
    var body: some View {
        
        // MARK: - Return View
        List(motionVM.coreMotionArray.reversed(), id: \.counter) { index in
            HStack {
                if index.counter > 0 {
                    Text("ID:\(motionVM.coreMotionArray[index.counter - 1].counter)", comment: "AccelerationList - ID")
                    Spacer()
                    Text("X:\(motionVM.coreMotionArray[index.counter - 1].accelerationXAxis, specifier: "%.5f")", comment: "AccelerationList - X")
                    Spacer()
                    Text("Y:\(motionVM.coreMotionArray[index.counter - 1].accelerationYAxis, specifier: "%.5f")", comment: "AccelerationList - Y")
                    Spacer()
                    Text("Z:\(motionVM.coreMotionArray[index.counter - 1].accelerationZAxis, specifier: "%.5f")", comment: "AccelerationList - Z")
                }
            }
            .font(.footnote)
        }
        .listStyle(PlainListStyle())
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 250, maxHeight: 250, alignment: .center)
    }
}


// MARK: - Preview
struct AccelerationList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            AccelerationList(motionVM: CoreMotionViewModel())
                .colorScheme(scheme)
                .previewLayout(.sizeThatFits)
        }
    }
}
