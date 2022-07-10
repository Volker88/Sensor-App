//
//  GravityList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct GravityList: View {
    @ObservedObject var motionVM: CoreMotionViewModel

    var body: some View {
        List(motionVM.coreMotionArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "GravityList - ID")
                Spacer()
                Text("X:\(item.gravityXAxis, specifier: "%.5f")", comment: "GravityList - X")
                Spacer()
                Text("Y:\(item.gravityYAxis, specifier: "%.5f")", comment: "GravityList - Y")
                Spacer()
                Text("Z:\(item.gravityZAxis, specifier: "%.5f")", comment: "GravityList - Z")
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

struct GravityList_Previews: PreviewProvider {
    static var previews: some View {
        GravityList(motionVM: CoreMotionViewModel())
            .previewLayout(.sizeThatFits)
    }
}
