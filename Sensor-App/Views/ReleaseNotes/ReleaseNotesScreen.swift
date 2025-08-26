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
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Close", action: dismiss.callAsFunction)
                            .buttonStyle(.glassProminent)
                    }
                    
                    ToolbarItem(placement: .automatic) {
                        Toggle("Show", isOn: $showReleaseNotes)
                            .accessibilityLabel("Show Release Notes")
                            .accessibilityValue("enabled", isEnabled: showReleaseNotes)
                            .accessibilityValue("disabled", isEnabled: !showReleaseNotes)
                            .accessibilityRemoveTraits(.isButton)
                            .accessibilityAddTraits(.isToggle)
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
