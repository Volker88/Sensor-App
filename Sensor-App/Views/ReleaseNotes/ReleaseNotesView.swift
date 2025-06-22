//
//  ReleaseNotesView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11/24/24.
//

import Sensor_App_Framework
import SwiftUI

struct ReleaseNotesView: View {

    // MARK: - Body
    var body: some View {
        List {
            Section {
                Text("Requires minimum iOS 26 and watchOS 26", tableName: "ReleaseNotes")
                Text("Adapt the new iOS 26 Liquid Glass Design", tableName: "ReleaseNotes")
                Text("Integration into Siri & Shortcuts", tableName: "ReleaseNotes")
                Text("Performance improvements an bug fixes", tableName: "ReleaseNotes")
            } header: {
                Text(verbatim: "6.0.0")
            }
        }
    }
}

#Preview("ReleaseNotesView - English") {
    ReleaseNotesView()
}

#Preview("ReleaseNotesView - German") {
    ReleaseNotesView()
        .previewLocalization(.german)
}
