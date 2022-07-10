//
//  GyroscopeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct GyroscopeList: View {
    @ObservedObject var motionVM: CoreMotionViewModel

    var body: some View {
        List(motionVM.coreMotionArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "GyroscopeList - ID")
                Spacer()
                Text("X:\(item.gyroXAxis, specifier: "%.5f")", comment: "GyroscopeList - X")
                Spacer()
                Text("Y:\(item.gyroYAxis, specifier: "%.5f")", comment: "GyroscopeList - Y")
                Spacer()
                Text("Z:\(item.gyroZAxis, specifier: "%.5f")", comment: "GyroscopeList - Z")
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

struct GyroscopeList_Previews: PreviewProvider {
    static var previews: some View {
        GyroscopeList(motionVM: CoreMotionViewModel())
            .previewLayout(.sizeThatFits)
    }
}
