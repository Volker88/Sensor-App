//
//  GyroscopeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

// MARK: - Import
import SwiftUI

// MARK: - Struct
struct GyroscopeList: View {

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

// MARK: - Preview
struct GyroscopeList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            GyroscopeList(motionVM: CoreMotionViewModel())
                .colorScheme(scheme)
                .previewLayout(.sizeThatFits)
        }
    }
}
