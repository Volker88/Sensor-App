//
//  ReleaseNotesScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11/24/24.
//

import Sensor_App_Framework
import SwiftUI

struct ReleaseNotesScreen: View {

    @Environment(\.dismiss) private var dismiss

    @AppStorage("showReleaseNotes") private var showReleaseNotes = true

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ReleaseNotesView()
                .navigationTitle("Release Notes")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close", systemImage: "xmark.circle", role: .close) {
                            dismiss()
                        }
                    }
                }
        }
    }
}

// MARK: - Preview
#Preview("ReleaseNotesScreen - English", traits: .navEmbedded) {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            ReleaseNotesScreen()
        }
}

#Preview("ReleaseNotesScreen - German", traits: .navEmbedded) {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            ReleaseNotesScreen()
        }
        .previewLocalization(.german)
}
