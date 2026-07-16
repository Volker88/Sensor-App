//
//  RecordingLocationMeasurementsView.swift
//  Sensor-App
//

import Sensor_App_Framework
import SwiftData
import SwiftUI

struct RecordingLocationMeasurementsView: View {

    let session: SensorSession

    private var sorted: [LocationMeasurement] {
        (session.locationMeasurements ?? []).sorted { $0.counter < $1.counter }
    }

    // MARK: - Body
    var body: some View {
        List(sorted) { measurement in
            DisclosureGroup {
                LabeledContent(
                    "Longitude", value: measurement.longitude.formatted(.number.precision(.fractionLength(6))))

                LabeledContent("Latitude", value: measurement.latitude.formatted(.number.precision(.fractionLength(6))))

                LabeledContent(
                    "Altitude (\(measurement.heightUnit))",
                    value: measurement.calculatedAltitude.formatted(.number.precision(.fractionLength(2))))

                LabeledContent(
                    "Speed (\(measurement.speedUnit))",
                    value: measurement.calculatedSpeed.formatted(.number.precision(.fractionLength(2))))

                LabeledContent("Course (°)", value: measurement.course.formatted(.number.precision(.fractionLength(2))))

                LabeledContent(
                    "H. Accuracy (\(measurement.horizontalAccuracyUnit))",
                    value: measurement.calculatedHorizontalAccuracy.formatted(.number.precision(.fractionLength(2))))

                LabeledContent(
                    "V. Accuracy (\(measurement.heightUnit))",
                    value: measurement.calculatedVerticalAccuracy.formatted(.number.precision(.fractionLength(2))))

                LabeledContent(
                    "GPS Accuracy", value: measurement.GPSAccuracy.formatted(.number.precision(.fractionLength(2))))

            } label: {
                HStack {
                    Text(verbatim: "#\(measurement.counter)")
                        .monospacedDigit()

                    Spacer()

                    Text(measurement.timestamp)
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
