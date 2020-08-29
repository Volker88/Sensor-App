//
//  ViewButtonModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 26.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - ContentView
struct ContentViewTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { g in
            content
                .frame(width: g.size.width, height: 100, alignment: .center)
                .font(.largeTitle)
                .background(Color("HeaderBackgroundColor"))
                .foregroundColor(Color("HeaderTextColor"))
                .cornerRadius(10)
                .multilineTextAlignment(.center)
        }
    }
}

extension View {
    func contentViewTitleModifier() -> some View {
        modifier(ContentViewTitleModifier())
    }
}
