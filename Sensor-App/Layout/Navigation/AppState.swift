//
//  AppState.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import SwiftUI

@Observable
class AppState {
    var path: [Route] = []
    var selectedScreen: Screen?
}
