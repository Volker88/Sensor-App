//
//  LineGraphSubView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import SwiftUI
import Charts

// MARK: - Struct
struct LineGraphSubView: View {

    // MARK: - Initialize Classes
    let settings = SettingsAPI()

    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM = CoreMotionViewModel() // :CoreMotionViewModel
    @ObservedObject var locationVM = CoreLocationViewModel()
    @StateObject var transformation = GraphArrayTransformation()

    // MARK: - Define Constants / Variables
    var showGraph: GraphDetail

    // MARK: - Methods
    func transformGraphArray() {
        if locationVM.coreLocationArray.count != 0 {
            transformation.transformLocation(locationModel: locationVM.coreLocationArray, graph: showGraph)
        } else if motionVM.coreMotionArray.count != 0 {
            transformation.transformMotion(motionModel: motionVM.coreMotionArray, graph: showGraph)
        } else if motionVM.altitudeArray.count != 0 {
            transformation.transformAltitude(altitudeModel: motionVM.altitudeArray, graph: showGraph)
        } else {
            transformation.addToArray(0)
        }
    }

    // MARK: - Body - View
    var body: some View {

        // MARK: - Return View
        return GeometryReader { _ in
            VStack {
                Chart(transformation.array) { item in
                    LineMark(
                        x: .value("", item.index),
                        y: .value("", item.value)
                    )
                }
                .chartXAxis(.hidden)
                .frame(
                    minWidth: 150,
                    idealWidth: 200,
                    maxWidth: .infinity,
                    minHeight: 0,
                    idealHeight: 100,
                    maxHeight: 100,
                    alignment: .leading
                )
            }
            .onChange(of: locationVM.coreLocationArray.count) { _ in
                transformGraphArray()
            }
            .onChange(of: motionVM.coreMotionArray.count) { _ in
                transformGraphArray()
            }
        }
    }
}

// MARK: - Preview
struct LineGraphImplementation_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            LineGraphSubView(showGraph: .speed)
                .colorScheme(scheme)
                .previewLayout(.sizeThatFits)
        }
    }
}
