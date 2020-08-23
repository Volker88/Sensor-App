//
//  MagnetometerList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct MagnetometerList: View {
    
    // MARK: - Initialize Classes
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM: CoreMotionViewModel
    
    
    // MARK: - Define Constants / Variables
    
    // MARK: - Methods
    
    // MARK: - Body - View
    var body: some View {
        
        // MARK: - Return View
        List(self.motionVM.coreMotionArray.reversed(), id: \.counter) { index in
            HStack{
                Text("ID:\(self.motionVM.coreMotionArray[index.counter - 1].counter)", comment: "MotionListView - ID")
                Spacer()
                Text("X:\(self.motionVM.coreMotionArray[index.counter - 1].magnetometerXAxis, specifier: "%.5f")", comment: "MotionListView - X")
                Spacer()
                Text("Y:\(self.motionVM.coreMotionArray[index.counter - 1].magnetometerYAxis, specifier: "%.5f")", comment: "MotionListView - Y")
                Spacer()
                Text("Z:\(self.motionVM.coreMotionArray[index.counter - 1].magnetometerZAxis, specifier: "%.5f")", comment: "MotionListView - Z")
            }
            .font(.footnote)
        }
        .listStyle(PlainListStyle())
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 250, maxHeight: 250, alignment: .center)
    }
}


// MARK: - Preview
struct MagnetometerList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            MagnetometerList(motionVM: CoreMotionViewModel())
                .colorScheme(scheme)
                .previewLayout(.sizeThatFits)
        }
    }
}
