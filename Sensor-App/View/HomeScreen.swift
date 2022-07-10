//
//  HomeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        Text("Hello, World!")
            .navigationTitle("\(NSLocalizedString("Home", comment: "NavigationBar Title - Home"))")
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
