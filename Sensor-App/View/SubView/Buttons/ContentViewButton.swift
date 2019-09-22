//
//  ContentViewButton.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 06.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - ButtonView
struct ContentViewButton: View {
    
    // MARK: - @State / @Binding Variables
    @State var type: ButtonType?
    @State var text: String
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        if type == .contentViewHeader {
            return GeometryReader { g in
                AnyView(
                    Text(NSLocalizedString(self.text, comment: "header"))
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .frame(width: g.size.width - 10, height: CGFloat(100), alignment: .center)
                        .background(Color("HeaderBackgroundColor"))
                        .foregroundColor(Color("HeaderTextColor"))
                        .cornerRadius(10)
                )
            }
        } else {
            return GeometryReader { g in
                AnyView(
                    Text(NSLocalizedString(self.text, comment: "button"))
                        .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .center)
                        .font(.title)
                        .foregroundColor(Color("StandardTextColor"))
                        .background(Color("StandardBackgroundColor"))
                        .cornerRadius(10)
                )
            }
        }
    }
}


// MARK: - Preview
struct ContentViewButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentViewButton(type: .contentViewHeader, text: "Welcome to the \n Sensor-App")
                .previewLayout(.sizeThatFits)
            ContentViewButton(type: .contentViewButton, text: "Accelerometer")
                .previewLayout(.sizeThatFits)
        }
    }
}
