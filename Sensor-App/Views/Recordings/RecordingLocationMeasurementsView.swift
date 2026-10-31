//
//  RecordingLocationMeasurementsView.swift
//  Sensor-App
//

import Sensor_App_Framework
import SwiftData
import SwiftUI

struct RecordingLocationMeasurementsView: View {

    let session: SensorSession

    // MARK: - Body
    var body: some View {
        RecordingSampleList(load: { try await session.loadLocationSamples() }, id: \.counter) { sample in
            DisclosureGroup {
                LabeledContent(
                    "Longitude", value: sample.longitude.formatted(.number.precision(.fractionLength(6))))

                LabeledContent("Latitude", value: sample.latitude.formatted(.number.precision(.fractionLength(6))))

                LabeledContent(
                    "Altitude (\(sample.heightUnit))",
                    value: sample.calculatedAltitude.formatted(.number.precision(.fractionLength(2))))

                LabeledContent(
                    "Speed (\(sample.speedUnit))",
                    value: sample.calculatedSpeed.formatted(.number.precision(.fractionLength(2))))

                LabeledContent("Course (°)", value: sample.course.formatted(.number.precision(.fractionLength(2))))

                LabeledContent(
                    "H. Accuracy (\(sample.horizontalAccuracyUnit))",
                    value: sample.calculatedHorizontalAccuracy.formatted(.number.precision(.fractionLength(2))))

                LabeledContent(
                    "V. Accuracy (\(sample.heightUnit))",
                    value: sample.calculatedVerticalAccuracy.formatted(.number.precision(.fractionLength(2))))

                LabeledContent(
                    "GPS Accuracy", value: sample.GPSAccuracy.formatted(.number.precision(.fractionLength(2))))

            } label: {
                HStack {
                    Text(verbatim: "#\(sample.counter)")
                        .monospacedDigit()

                    Spacer()

                    Text(sample.timestamp)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Location Measurements")
    }
}

// MARK: - Preview
#Preview("RecordingLocationMeasurementsView - English", traits: .navEmbedded) {
    RecordingLocationMeasurementsView(session: SensorSession.mockSession())
}

#Preview("RecordingLocationMeasurementsView - German", traits: .navEmbedded) {
    RecordingLocationMeasurementsView(session: SensorSession.mockSession())
        .previewLocalization(.german)
}
