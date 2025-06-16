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
                Text("Small bug fixes", comment: "Release notes")
            } header: {
                Text(verbatim: "5.2.1")
            }

            Section {
                Text("Small bug fixes", comment: "Release notes")
            } header: {
                Text(verbatim: "5.2.0")
            }

            Section {
                Text("Added Knots as additional speed setting", comment: "Release notes")
                Text("Small bug fixes", comment: "Release notes")
            } header: {
                Text(verbatim: "5.1.0")
            }

            Section {
                Text(
                    "Fixed a bug which caused the app to crash if no permissions to sensors were granted",
                    comment: "Release notes")
            } header: {
                Text(verbatim: "5.0.1")
            }

            Section {
                Text(
                    "Requires minimum iOS 18 and watchOS 11",
                    comment: "Release notes")
                Text("Performance improvements an bug fixes", comment: "Release notes")
            } header: {
                Text(verbatim: "5.0.0")
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
