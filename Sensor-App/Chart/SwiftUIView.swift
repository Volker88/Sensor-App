//
//  SwiftUIView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 30.12.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


import SwiftUI


struct SwiftUIView: View {
    
    var maxGraphWidth : Double
    var maxGraphHeight : Double
    var maxPoints = 30
    
    @State var minValue : Double = -10
    @State var maxValue : Double = 10
    
    @State private var transformedArray : [Double] = [0]
    
    @State var data : [Double] = [0,4,6,10,50,100,-20,-100,-200, 50, -100, 4, 6, 10, 50, 100, -20, -100, -200, -100] {
        didSet {
            // Check for maximum elements in Array and remove first to keep the max
            defer {
                self.transformedArray = calculateArray(array: data, _maxGraphHeight: maxGraphHeight)
                print("transformed \(transformedArray)")
            }
            
            if data.count > maxPoints {
                data.removeFirst()
                print("Removed item")
            }
        }
    }
    
    
    // Calculate array to fit in graph
    func calculateArray(array: [Double], _maxGraphHeight: Double) -> [Double] {
        let dataArray = array
        let maxGraphHeight = _maxGraphHeight
        
        //let dataArrayMaxValue = dataArray.map(abs).max() ?? 10 // Absolute Maximum
        guard let dataArrayMaxValue = dataArray.map(abs).max() else { return dataArray }
        
        
        self.minValue = dataArrayMaxValue * (-1)
        self.maxValue = dataArrayMaxValue
        
        print("Abs. Max. \(dataArrayMaxValue)")
        print("Min. \(self.minValue)")
        print("Max. \(self.maxValue)")
        let scaleFactor = maxGraphHeight / dataArrayMaxValue
        
        let ar = dataArray.map() { ($0 * scaleFactor / 2) }
        
        return ar
    }
    
    
    // MARK: - Debug to generate Array
    func generateArray() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (_) in
            let random = Double.random(in: -100...100).rounded(toPlaces: 1)
            
            self.data.append(random)
        }
    }
    
    var body: some View {
        
        return HStack(spacing: 0) {
            VStack {
                Group {
                    Text("\(self.maxValue, specifier: "%.5f")")
                    Spacer()
                    Text("0")
                    Spacer()
                    Text("\(self.minValue, specifier: "%.5f")")
                }
                .font(.caption)
            }
            .frame(width: CGFloat(75), height: CGFloat(maxGraphHeight), alignment: .trailing)
            //.border(Color(.red), width: 1)
            
            VStack {
                ZStack {
                    
                    Rectangle()
                        .frame(width: CGFloat(maxGraphWidth) - 75, height: 0.5, alignment: .center)
                    
                    Path.test(points: self.transformedArray, width: maxGraphWidth - 75)
                        .trim(from: 0, to: 1)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .leading, endPoint: .trailing) ,style: StrokeStyle(lineWidth: 3))
                        .rotationEffect(.degrees(180), anchor: .center)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .animation(.easeOut(duration: 1.2))
                        .drawingGroup()
                    
                }
            }
            .frame(height: CGFloat(maxGraphHeight))
            .border(Color("StandardTextColor"), width: 1)
            
        }
        .frame(width: CGFloat(maxGraphWidth), height: CGFloat(maxGraphHeight), alignment: .center)
        .onAppear(perform: generateArray)
        
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SwiftUIView(maxGraphWidth: 350, maxGraphHeight: 300, minValue: -10, maxValue: 10)
                .previewLayout(.sizeThatFits)
            SwiftUIView(maxGraphWidth: 350, maxGraphHeight: 300, minValue: -10, maxValue: 10)
                .environment(\.colorScheme, .dark)
                .previewLayout(.sizeThatFits)
        }
    }
}


extension Path {
    static func test(points: [Double], width: Double) -> Path {
        var path = Path()
        var p1 = CGPoint(x: 0, y: points[0] + points.min()! * (-1))
        path.move(to: p1)
        
        for pointIndex in 1..<points.count {
            let x = Double(pointIndex) * width / Double(points.count)
            let p2 = CGPoint(x: x, y: points[pointIndex] + points.min()! * (-1))
            path.addLine(to: p2)
            p1 = p2
        }
        return path
        
    }
}

