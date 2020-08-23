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
                .frame(width: g.size.width - 10, height: 100, alignment: .center)
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
        self.modifier(ContentViewTitleModifier())
    }
}

struct ContentViewButtonModifier: ViewModifier {
    let accessibility: String
    func body(content: Content) -> some View {
        GeometryReader { g in
            content
                .hoverEffect()
                .frame(width: g.size.width - 10, height: 50, alignment: .center)
                .font(.title)
                .background(Color("StandardBackgroundColor"))
                .foregroundColor(Color("StandardTextColor"))
                .cornerRadius(10)
                .accessibility(identifier: self.accessibility)
        }
    }
}

extension View {
    func contentViewButtonModifier(accessibility: String) -> some View {
        self.modifier(ContentViewButtonModifier(accessibility: accessibility))
    }
}


// MARK: - Location / Motion
struct ButtonTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { g in
            content
                .frame(width: g.size.width - 10, height: 50, alignment: .center)
                .font(.largeTitle)
                .background(Color("HeaderBackgroundColor"))
                .foregroundColor(Color("HeaderTextColor"))
                .cornerRadius(10)
        }
    }
}

extension View {
    func buttonTitleModifier() -> some View {
        self.modifier(ButtonTitleModifier())
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { g in
            content
                .frame(width: g.size.width - 10, height: 50, alignment: .leading)
                .font(.body)
                .background(Color("StandardBackgroundColor"))
                .foregroundColor(Color("StandardTextColor"))
                .cornerRadius(10)
        }
    }
}

extension View {
    func buttonModifier() -> some View {
        self.modifier(ButtonModifier())
    }
}


// MARK: - Refresh Model
struct RefreshRateLimitLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 50, height: 50, alignment: .center)
            .font(.body)
            .background(Color("StandardBackgroundColor"))
            .foregroundColor(Color("StandardTextColor"))
            .cornerRadius(10)
    }
}


extension View {
    func refreshRateLimitLabelModifier() -> some View {
        self.modifier(RefreshRateLimitLabel())
    }
}


