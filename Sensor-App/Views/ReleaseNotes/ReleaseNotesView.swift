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
                Text("Added a feature request and voting board", tableName: "ReleaseNotes")
                Text("Start and stop recordings directly from the Recordings tab", tableName: "ReleaseNotes")
                Text("See live sample counts while a recording is running", tableName: "ReleaseNotes")
                Text("Recordings keep running while you switch between sensors", tableName: "ReleaseNotes")
                Text(
                    "Each recording starts with a clean slate, so it only contains data captured after you tap Record",
                    tableName: "ReleaseNotes")
                Text(
                    "Pause and Delete are disabled during a recording to prevent gaps or lost data",
                    tableName: "ReleaseNotes")
                Text("Recorded Sessions can be renamed", tableName: "ReleaseNotes")
                Text("Keep the screen on while recording (can be turned off in Settings)", tableName: "ReleaseNotes")
                Text("Choose a Light, Dark, or System color theme in Settings", tableName: "ReleaseNotes")
            } header: {
                Text(verbatim: "7.2.0")
                    .accessibilityLabel(Text("Version 7.2.0", tableName: "ReleaseNotes"))
            }

            Section {
                Text("Optimized for iPhone Duo", tableName: "ReleaseNotes")
            } header: {
                Text(verbatim: "7.1.0")
                    .accessibilityLabel(Text("Version 7.1.0", tableName: "ReleaseNotes"))
            }

            Section {
                Text("Requires minimum iOS 27 and watchOS 27", tableName: "ReleaseNotes")
                Text("Record sensor sessions with timestamps and review them anytime", tableName: "ReleaseNotes")
                Text(
                    "Recorded sensor sessions can be synchronised across devices via iCloud", tableName: "ReleaseNotes")
                Text("View session statistics: minimum, maximum, and average", tableName: "ReleaseNotes")
                Text("Expand any graph to full screen in portrait or landscape", tableName: "ReleaseNotes")
            } header: {
                Text(verbatim: "7.0.0")
                    .accessibilityLabel(Text("Version 7.0.0", tableName: "ReleaseNotes"))
            }

            Section {
                Text("Requires minimum iOS 26 and watchOS 26", tableName: "ReleaseNotes")
                Text("Adapt the new iOS 26 Liquid Glass Design", tableName: "ReleaseNotes")
                Text("Integration into Siri & Shortcuts", tableName: "ReleaseNotes")
                Text("Accessibility improvements", tableName: "ReleaseNotes")
                Text("Performance improvements and bug fixes", tableName: "ReleaseNotes")
            } header: {
                Text(verbatim: "6.0.0")
                    .accessibilityLabel(Text("Version 6.0.0", tableName: "ReleaseNotes"))
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
