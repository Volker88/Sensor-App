//
//  MagnetometerList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct MagnetometerList: View {
    @ObservedObject var motionVM: CoreMotionViewModel

    var body: some View {
        List(motionVM.coreMotionArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "MagnetometerList - ID")
                Spacer()
                Text("X:\(item.magnetometerXAxis, specifier: "%.5f")", comment: "MagnetometerList - X")
                Spacer()
                Text("Y:\(item.magnetometerYAxis, specifier: "%.5f")", comment: "MagnetometerList - Y")
                Spacer()
                Text("Z:\(item.magnetometerZAxis, specifier: "%.5f")", comment: "MagnetometerList - Z")
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

struct MagnetometerList_Previews: PreviewProvider {
    static var previews: some View {
        MagnetometerList(motionVM: CoreMotionViewModel())
            .previewLayout(.sizeThatFits)
    }
}
