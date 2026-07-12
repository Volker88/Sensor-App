//
//  RecordingsScreen.swift
//  Sensor-App
//

import Sensor_App_Framework
import SwiftData
import SwiftUI

struct RecordingsScreen: View {

    @Environment(RecordingManager.self) private var recordingManager
    @Query(sort: \SensorSession.startedAt, order: .reverse) private var sessions: [SensorSession]

    // MARK: - Body
    var body: some View {
        List {
            if sessions.isEmpty {
                ContentUnavailableView(
                    "No Recordings Yet",
                    systemImage: "record.circle",
                    description: Text("Start a recording using the controls on any sensor screen.")
                )
                .listRowBackground(Color.clear)
            } else {
                ForEach(sessions) { session in
                    NavigationLink(value: RecordingsStack.detail(session)) {
                        RecordingRow(session: session)
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .navigationTitle(Text("Recordings"))
        .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.list)
    }

    // MARK: - Methods
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            recordingManager.delete(sessions[index])
        }
    }
}

// MARK: - Preview
#Preview("RecordingsScreen - English", traits: .navEmbedded) {
    RecordingsScreen()
}

#Preview("RecordingsScreen - German", traits: .navEmbedded) {
    RecordingsScreen()
        .previewLocalization(.german)
}
