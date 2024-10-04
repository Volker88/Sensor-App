//
//  DeviceType.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 31.08.2024.
//

import XCTest

@MainActor func isIPad() -> Bool {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return true
    } else {
        return false
    }
}

@MainActor func isIPhone() -> Bool {
    if UIDevice.current.userInterfaceIdiom == .phone {
        return true
    } else {
        return false
    }
}
