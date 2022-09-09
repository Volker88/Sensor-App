//
//  ReleaseNotes.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11.10.20.
//

import SwiftUI

struct ReleaseNotes: View {
    @Environment(\.dismiss) var dismiss

    let settings = SettingsAPI()

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
                    .onChange(of: showReleaseNotes, perform: { value in
                        toggleSwitch(value: value)
                    })
                }
            }
            .onAppear(perform: onAppear)
        }
    }

    func toggleSwitch(value: Bool) {
        var userSettings = settings.fetchUserSettings()
        userSettings.showReleaseNotes = value
        settings.saveUserSettings(userSettings: userSettings)

        Log.shared.add(.appUpdates, .default, "Show Release Notes: \(value)")
    }

    func onAppear() {
        showReleaseNotes = settings.fetchUserSettings().showReleaseNotes
        releaseNotes = loadJson()
    }

    func loadJson() -> [ReleaseNotesModel] {
        let notes = Bundle.main.decode([ReleaseNotesModel].self, from: "ReleaseNotes.json")
        return notes
    }
}

struct ReleaseNotes_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseNotes()
    }
}
