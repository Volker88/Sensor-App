//
//  LineGraphSubView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI
import SwiftUIGraph


// MARK: - Struct
struct LineGraphSubView: View {
    
    // MARK: - Initialize Classes
    let settings = SettingsAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM = CoreMotionViewModel()
    @ObservedObject var locationVM = CoreLocationViewModel()
    @ObservedObject var transformation = GraphArrayTransformation()
    
    
    // MARK: - Define Constants / Variables
    var showGraph: GraphDetail
    

    // MARK: - Methods
    func transformGraphArray() {
        if locationVM.coreLocationArray.count != 0 {
            transformation.transformLocation(locationModel: locationVM.coreLocationArray, graph: showGraph)
        } else if motionVM.coreMotionArray.count != 0  {
            transformation.transformMotion(motionModel: motionVM.coreMotionArray, graph: showGraph)
        } else if motionVM.altitudeArray.count != 0 {
            transformation.transformAltitude(altitudeModel: motionVM.altitudeArray, graph: showGraph)
        } else {
            transformation.array = [0.0]
        }
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        let lineGraphSettings: LineGraphSettings = LineGraphSettings(maxPoints: settings.fetchUserSettings().graphMaxPoints, decimalDigits: 3, lineWitdh: 2, lineColor: [.secondary], textColor: .primary)
        transformGraphArray()
        
        
        // MARK: - Return View
        return GeometryReader { g in
            VStack{
                LineGraphView(lineGraphPointsArray: transformation.array, lineGraphSettings: lineGraphSettings, graphWidth: g.size.width - 10, graphHeight: 100)
                    .frame(minWidth: 150, idealWidth: 200, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: 100, alignment: .leading)
            }
        }
    }
}


// MARK: - Preview
struct LineGraphImplementation_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            LineGraphSubView(locationVM: CoreLocationViewModel(), showGraph: .speed)
                .colorScheme(scheme)
                .previewLayout(.sizeThatFits)
        }
    }
}
