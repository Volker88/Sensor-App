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
    @State private var sessionToRename: SensorSession?
    @State private var renameText = ""

    // MARK: - Body
    var body: some View {
        List {
            RecordingControlSection()

            if sessions.isEmpty {
                ContentUnavailableView(
                    "No Recordings Yet",
                    systemImage: "record.circle",
                    description: Text("Tap Start Recording above, or use the controls on any sensor screen.")
                )
                .listRowBackground(Color.clear)
            } else {
                ForEach(sessions) { session in
                    NavigationLink(value: NavigationRoute.recordings(.detail(session))) {
                        RecordingRow(session: session)
                    }
                    // Custom swipe actions replace the ones `onDelete` would synthesize, so Delete is
                    // declared explicitly here.
                    .swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            recordingManager.delete(session)
                        }
                        .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.deleteSwipeButton)

                        Button("Rename", systemImage: "pencil") {
                            beginRename(session)
                        }
                        .tint(.accentColor)
                        .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.renameSwipeButton)
                    }
                    .contextMenu {
                        Button("Rename", systemImage: "pencil") {
                            beginRename(session)
                        }
                        .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.renameContextMenuButton)

                        Button("Delete", systemImage: "trash", role: .destructive) {
                            recordingManager.delete(session)
                        }
                        .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.deleteContextMenuButton)
                    }
                }
            }
        }
        .navigationTitle(Text("Recordings"))
        .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.list)
        .alert("Rename Recording", item: $sessionToRename) { session in
            TextField("Recording Name", text: $renameText)
                .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.renameTextField)

            Button("Cancel", role: .cancel) {}

            Button("Rename") {
                // An empty or whitespace-only name is rejected and the session keeps its old name.
                recordingManager.rename(session, to: renameText)
            }
            .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.renameConfirmButton)
        }
    }

    // MARK: - Methods
    private func beginRename(_ session: SensorSession) {
        renameText = session.name
        sessionToRename = session
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
