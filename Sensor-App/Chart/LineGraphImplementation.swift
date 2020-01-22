//
//  LineGraphImplementation.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import SwiftUI
import SwiftUIGraph

struct LineGraphImplementation: View, LineGraphPotocol {
    
  
    @ObservedObject var locationVM = CoreLocationViewModel()
    @ObservedObject var transformation = ArrayTransformation()
    
    @State var lineGraphPointsArray: [Double] = [-100,-50,-50,0,0,50,50,100] // unused
    
    
    var lineGraphSettings: LineGraphSettings = LineGraphSettings(maxPoints: 10, decimalDigits: 3, lineWitdh: 2, lineColor: [.red, .blue, .yellow], textColor: .primary, borderColor: .red, borderWidth: 1)
    
    
    
    
//    // MARK: - Debug to generate Array
//    func generateArray() {
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (_) in
//            let random = Double.random(in: -100...100).rounded(toPlaces: 1)
//
//            self.lineGraphPointsArray.append(random)
//        }
//    }
//

    func callTransformation() {
        transformation.transform(model: locationVM.coreLocationArray)
    }
    
   
    var body: some View {
        
        callTransformation()
    
        print(transformation.array)
        
        return GeometryReader { g in
            VStack{
                Text("\(self.transformation.array.last!, specifier: "%.5f")")
                LineGraphView(lineGraphPointsArray: self.transformation.array, lineGraphSettings: self.lineGraphSettings, graphWidth: g.size.width - 10, graphHeight: 200)
        }
        }
        //.onAppear(perform: generateArray)
    }
}

//struct LineGraphImplementation_Previews: PreviewProvider {
//    static var previews: some View {
//
//        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
//            LineGraphImplementation(locationVM: CoreLocationViewModel)
//                .colorScheme(scheme)
//        }
//    }
//}
