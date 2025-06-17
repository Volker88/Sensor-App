//
//  AppState.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import SwiftUI

@Observable
class AppState {

    #if os(iOS)
        var isIphone: Bool {
            UIDevice.current.userInterfaceIdiom == .phone
        }
    #else
        let isIphone = false
    #endif

    var selectedTab: RootTab = .position

    // MARK: - Navigation Stacks
    var positionStack: [PositionStack] = []
    var motionStack: [MotionStack] = []
    var magnetometerStack: [MagnetometerStack] = []

    /// Reset Stack
    func resetStack() {
        positionStack.removeAll()
        motionStack.removeAll()
        magnetometerStack.removeAll()
    }
}
