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
