//
//  AttitudeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AttitudeList: View {
    @ObservedObject var motionVM: CoreMotionViewModel

    var body: some View {
        List(motionVM.coreMotionArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "AttitudeList - ID")
                Spacer()
                Text("R:\(item.attitudeRoll * 180 / .pi, specifier: "%.3f")", comment: "AttitudeList - R")
                Spacer()
                Text("P:\(item.attitudePitch * 180 / .pi, specifier: "%.3f")", comment: "AttitudeList - P")
                Spacer()
                Text("Y:\(item.attitudeYaw * 180 / .pi, specifier: "%.3f")", comment: "AttitudeList - Yield")
                Spacer()
                Text("H:\(item.attitudeHeading, specifier: "%.3f")", comment: "AttitudeList - H")
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

struct AttitudeList_Previews: PreviewProvider {
    static var previews: some View {
        AttitudeList(motionVM: CoreMotionViewModel())
            .previewLayout(.sizeThatFits)
    }
}
