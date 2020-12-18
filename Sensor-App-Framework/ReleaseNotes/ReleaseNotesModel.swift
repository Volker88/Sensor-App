//
//  ReleaseNotesModel.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.10.20.
//

// MARK: - Import
import SwiftUI

// MARK: - Struct Definition
struct ReleaseNotesModel: Codable, Identifiable {
    var id: Int
    let version: String
    let notes: [String]
}
#if !DEBUG
#warning("Update Release Notes")
#endif
