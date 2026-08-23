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
