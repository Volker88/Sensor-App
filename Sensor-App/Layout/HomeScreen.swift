//
//  HomeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import Sensor_App_Framework
import SwiftUI

struct HomeScreen: View {

    // MARK: - Body
    var body: some View {
        Text("Welcome to Sensor-App")
            .navigationTitle("\(Text("Home", comment: "NavigationBar Title - Home"))")
    }
}

// MARK: - Preview
#Preview("HomeScreen - English", traits: .navEmbedded) {
    HomeScreen()
}

#Preview("HomeScreen - German", traits: .navEmbedded) {
    HomeScreen()
        .previewLocalization(.german)
}
