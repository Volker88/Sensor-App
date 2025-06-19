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

    /// Button to close View
    var closeButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "xmark.circle")
                .navigationBarItemModifier(accessibility: "Close")
        }
    }

    // MARK: - Body
    var body: some View {
        ReleaseNotesView()
            .navigationTitle("Release Notes")
            .navigationBarItems(leading: closeButton)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Toggle(
                        isOn: $showReleaseNotes,
                        label: {
                            Text("Show")
                        }
                    )
                    .toggleStyle(.switch)
                }
            }
            .navigationStackWrapper()
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
