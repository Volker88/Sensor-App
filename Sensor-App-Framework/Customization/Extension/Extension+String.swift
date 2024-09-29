//
//  Extension+String.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.10.20.
//

import SwiftUI

extension String: Swift.Identifiable {
    public var id: String {
        self
    }
}
