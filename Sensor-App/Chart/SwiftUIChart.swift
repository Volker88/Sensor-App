//
//  SwiftUIChart.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 30.12.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct SwiftUIChart: View {
    
    var graphWidth = 350.0
    var graphHeight = 600.0
    
    var body: some View {
        
        
    
        return SwiftUIView(maxGraphWidth: self.graphWidth, maxGraphHeight: self.graphHeight)
            
            
        
    }
}

struct SwiftUIChart_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIChart()
    }
}
