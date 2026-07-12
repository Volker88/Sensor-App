//
//  RecordingDetailView.swift
//  Sensor-App
//

import Sensor_App_Framework
import SwiftData
import SwiftUI

struct RecordingDetailView: View {

    let session: SensorSession

    // MARK: - Body
    var body: some View {
        List {
            Section("Session Info") {
                LabeledContent("Source", value: session.source)

                LabeledContent("Start Time", value: session.startedAt.formatted(date: .abbreviated, time: .shortened))

                if let endedAt = session.endedAt {
                    LabeledContent("End Time", value: endedAt.formatted(date: .abbreviated, time: .shortened))
                }

                if let duration = session.duration {
                    LabeledContent(
                        "Duration",
                        value: Duration.seconds(duration).formatted(
                            .units(allowed: [.hours, .minutes, .seconds], width: .wide)))
                }
            }

            Section("Measurements") {
                let motionCount = session.motionMeasurements?.count ?? 0
                let altitudeCount = session.altitudeMeasurements?.count ?? 0
                let locationCount = session.locationMeasurements?.count ?? 0

                if motionCount > 0 {
                    NavigationLink(value: RecordingsStack.motionMeasurements(session)) {
                        LabeledContent("Motion", value: motionCount.formatted())
                    }
                } else {
                    LabeledContent("Motion", value: motionCount.formatted())
                }

                if altitudeCount > 0 {
                    NavigationLink(value: RecordingsStack.altitudeMeasurements(session)) {
                        LabeledContent("Altitude", value: altitudeCount.formatted())
                    }
                } else {
                    LabeledContent("Altitude", value: altitudeCount.formatted())
                }

                if locationCount > 0 {
                    NavigationLink(value: RecordingsStack.locationMeasurements(session)) {
                        LabeledContent("Location", value: locationCount.formatted())
                    }
                } else {
                    LabeledContent("Location", value: locationCount.formatted())
                }
            }
        }
    }
}

// MARK: - Preview
#Preview("RecordingDetailView - English", traits: .navEmbedded) {
    RecordingDetailView(session: SensorSession.mockSession())
}

#Preview("RecordingDetailView - German", traits: .navEmbedded) {
    RecordingDetailView(session: SensorSession.mockSession())
        .previewLocalization(.german)
}
