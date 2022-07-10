//
//  AltitudeList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AltitudeList: View {
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()

    @ObservedObject var motionVM: CoreMotionViewModel

    var body: some View {
        List(motionVM.altitudeArray.reversed(), id: \.self) { item in
            HStack {
                Text("ID:\(item.counter)", comment: "AltitudeList - ID")
                Spacer()
                Text("P:\(calculationAPI.calculatePressure(pressure: item.pressureValue, to: settings.fetchUserSettings().pressureSetting), specifier: "%.5f")", comment: "AltitudeList - P") // swiftlint:disable:this line_length
                Spacer()
                Text("A:\(calculationAPI.calculateHeight(height: item.relativeAltitudeValue, to: settings.fetchUserSettings().altitudeHeightSetting), specifier: "%.5f")", comment: "AltitudeList - A") // swiftlint:disable:this line_length
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

struct AltitudeList_Previews: PreviewProvider {
    static var previews: some View {
        AltitudeList(motionVM: CoreMotionViewModel())
            .previewLayout(.sizeThatFits)
    }
}
