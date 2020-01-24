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
struct LineGraphSubView: View, LineGraphPotocol {
    
    // MARK: - @State / @ObservedObject
    @ObservedObject var motionVM = CoreMotionViewModel()
    @ObservedObject var locationVM = CoreLocationViewModel()
    @ObservedObject var transformation = GraphArrayTransformation()
    
    
    // MARK: - Define Constants / Variables
    var showGraph: GraphDetail
    var lineGraphSettings: LineGraphSettings = LineGraphSettings(maxPoints: 50, decimalDigits: 3, lineWitdh: 2, lineColor: [.secondary], textColor: .primary)
    
   
    // MARK: - Methods
    func transformGraphArray() {
        if locationVM.coreLocationArray.count != 0 {
            transformation.transformLocation(locationModel: locationVM.coreLocationArray, graph: showGraph)
        } else if motionVM.coreMotionArray.count != 0  {
            transformation.transformMotion(motionModel: motionVM.coreMotionArray, graph: showGraph)
        } else if motionVM.altitudeArray.count != 0 {
            transformation.transformAltitude(altitudeModel: motionVM.altitudeArray, graph: showGraph)
        }
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        transformGraphArray()
        
        
        // MARK: - Return View
        return GeometryReader { g in
            VStack{
                LineGraphView(lineGraphPointsArray: self.transformation.array, lineGraphSettings: self.lineGraphSettings, graphWidth: g.size.width - 10, graphHeight: 100)
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
