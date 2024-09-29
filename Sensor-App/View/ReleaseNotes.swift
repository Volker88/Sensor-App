//
//  ReleaseNotes.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11.10.20.
//

import SwiftUI
import OSLog

struct ReleaseNotes: View {

    @Environment(\.dismiss) var dismiss
    @Environment(SettingsManager.self) private var settingsManager

    @State private var showReleaseNotes = true
    @State private var releaseNotes: [ReleaseNotesModel]?

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
        NavigationStack {
            List {
                if let releaseNotes = releaseNotes {
                    ForEach(releaseNotes.reversed()) { item in
                        Section(header: Text("\(item.version)")) {

                            ForEach(item.notes) { note in
                                Text("\(note)")
                                    .font(.footnote)
                            }

                        }
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Release Notes", comment: "Release Notes - Title"))
            .navigationBarItems(leading: closeButton)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Toggle(isOn: $showReleaseNotes, label: {
                        Text("Show")
                    })
                    .toggleStyle(.switch)
                    .onChange(of: showReleaseNotes) { _, value in
                        toggleSwitch(value: value)
                    }
                }
            }
            .onAppear(perform: onAppear)
        }
    }

    // MARK: - Methods
    func toggleSwitch(value: Bool) {
        var userSettings = settingsManager.fetchUserSettings()
        userSettings.showReleaseNotes = value
        settingsManager.saveUserSettings(userSettings: userSettings)

        Logger.appUpdate.debug("Show Release Notes: \(value)")
    }

    func onAppear() {
        showReleaseNotes = settingsManager.fetchUserSettings().showReleaseNotes
        releaseNotes = loadJson()
    }

    func loadJson() -> [ReleaseNotesModel] {
        let notes = Bundle.main.decode([ReleaseNotesModel].self, from: "ReleaseNotes.json")
        return notes
    }
}

// MARK: - Preview
#Preview {
    ReleaseNotes()
        .previewNavigationStackWrapper()
}
