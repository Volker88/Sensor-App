//
//  Extension+URL.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 10.10.20.
//

import SwiftUI

extension Foundation.URL: Swift.Identifiable {
    public var id: URL {
        self
    }
}
