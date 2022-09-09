//
//  HomeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        Text("Welcome to Sensor-App")
            .navigationTitle("\(NSLocalizedString("Home", comment: "NavigationBar Title - Home"))")
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
