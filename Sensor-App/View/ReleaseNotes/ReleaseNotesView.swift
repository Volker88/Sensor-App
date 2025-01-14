//
//  ReleaseNotesView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11/24/24.
//

import SwiftUI

struct ReleaseNotesView: View {

    // MARK: - Body
    var body: some View {
        List {
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
