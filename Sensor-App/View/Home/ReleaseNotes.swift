//
//  ReleaseNotes.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11.10.20.
//

import SwiftUI

struct ReleaseNotes: View {

    // MARK: - Environment Objects
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Initialize Classes
    let settings = SettingsAPI()

    // MARK: - @State / @ObservedObject / @Binding
    @State private var showReleaseNotes = true
    @State private var releaseNotes: [ReleaseNotesModel]?

    // MARK: - Content
    var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle")
                .navigationBarItemModifier(accessibility: "Close")
        }
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
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
            .navigationBarTitle(NSLocalizedString("Release Notes", comment: "Release Notes - Title"), displayMode: .inline) //swiftlint:disable:this line_length
            .navigationBarItems(leading: closeButton)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Toggle(isOn: $showReleaseNotes, label: {
                        Text("Show")
                    })
                    .onChange(of: showReleaseNotes, perform: { value in
                        toggleSwitch(value: value)
                    })
                }
            }
            .onAppear(perform: onAppear)
        }
    }

    // MARK: - Methods
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

// MARK: - Preview
struct ReleaseNotes_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            ReleaseNotes()
                .colorScheme(scheme)
        }
    }
}
