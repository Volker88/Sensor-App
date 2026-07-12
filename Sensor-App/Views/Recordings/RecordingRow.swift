//
//  RecordingRow.swift
//  Sensor-App
//

import Sensor_App_Framework
import SwiftData
import SwiftUI

struct RecordingRow: View {

    let session: SensorSession

    // MARK: - Body
    var body: some View {
        HStack {
            Image(systemName: session.source == "Apple Watch" ? "applewatch" : "iphone")
                .foregroundStyle(.secondary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(session.name)
                    .font(.headline)

                Text(session.startedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if session.isCompleted, let duration = session.duration {
                Text(
                    Duration.seconds(duration).formatted(
                        .units(allowed: [.hours, .minutes, .seconds], width: .condensedAbbreviated))
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            } else if !session.isCompleted {
                Label("In Progress", systemImage: "record.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }
}

// MARK: - Preview
#Preview("RecordingRow - English", traits: .navEmbedded) {
    RecordingRow(session: SensorSession.mockSession())
}

#Preview("RecordingRow - German", traits: .navEmbedded) {
    RecordingRow(session: SensorSession.mockSession())
        .previewLocalization(.german)
}
