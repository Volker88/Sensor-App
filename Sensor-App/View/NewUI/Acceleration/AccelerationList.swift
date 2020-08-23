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
        List(self.motionVM.coreMotionArray.reversed(), id: \.counter) { index in
            HStack{
                Text("ID:\(self.motionVM.coreMotionArray[index.counter - 1].counter)", comment: "MotionListView - ID")
                    .foregroundColor(Color("ListTextColor"))
                Spacer()
                Text("X:\(self.motionVM.coreMotionArray[index.counter - 1].accelerationXAxis, specifier: "%.5f")", comment: "MotionListView - X")
                    .foregroundColor(Color("ListTextColor"))
                Spacer()
                Text("Y:\(self.motionVM.coreMotionArray[index.counter - 1].accelerationYAxis, specifier: "%.5f")", comment: "MotionListView - Y")
                    .foregroundColor(Color("ListTextColor"))
                Spacer()
                Text("Z:\(self.motionVM.coreMotionArray[index.counter - 1].accelerationZAxis, specifier: "%.5f")", comment: "MotionListView - Z")
                    .foregroundColor(Color("ListTextColor"))
            }
            .font(.footnote)
            .id(UUID())
        }
        //.animation(nil)
        .id(UUID())
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
