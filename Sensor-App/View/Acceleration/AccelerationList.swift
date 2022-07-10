//
//  AccelerationList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AccelerationList: View {
    @ObservedObject var motionVM: CoreMotionViewModel

    var body: some View {
        List(motionVM.coreMotionArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "AccelerationList - ID")
                Spacer()
                Text("X:\(item.accelerationXAxis, specifier: "%.5f")", comment: "AccelerationList - X")
                Spacer()
                Text("Y:\(item.accelerationYAxis, specifier: "%.5f")", comment: "AccelerationList - Y")
                Spacer()
                Text("Z:\(item.accelerationZAxis, specifier: "%.5f")", comment: "AccelerationList - Z")
            }
            .font(.footnote)
        }
        .listStyle(PlainListStyle())
        .frame(
            minWidth: 0,
            idealWidth: 100,
            maxWidth: .infinity,
            minHeight: 0,
            idealHeight: 250,
            maxHeight: 250,
            alignment: .center
        )
    }
}

struct AccelerationList_Previews: PreviewProvider {
    static var previews: some View {
        AccelerationList(motionVM: CoreMotionViewModel())
            .previewLayout(.sizeThatFits)
    }
}
