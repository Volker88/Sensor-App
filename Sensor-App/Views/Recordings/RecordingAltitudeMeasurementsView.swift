//
//  RecordingAltitudeMeasurementsView.swift
//  Sensor-App
//

import Sensor_App_Framework
import SwiftData
import SwiftUI

struct RecordingAltitudeMeasurementsView: View {

    let session: SensorSession

    private var sorted: [AltitudeMeasurement] {
        (session.altitudeMeasurements ?? []).sorted { $0.counter < $1.counter }
    }

    // MARK: - Body
    var body: some View {
        List(sorted) { measurement in
            DisclosureGroup {
                LabeledContent(
                    "Pressure (kPa)", value: measurement.pressureValue.formatted(.number.precision(.fractionLength(5))))

                LabeledContent(
                    "Rel. Altitude (m)",
                    value: measurement.relativeAltitudeValue.formatted(.number.precision(.fractionLength(5))))
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
        .navigationTitle("Altitude Measurements")
    }
}

// MARK: - Preview
#Preview("RecordingAltitudeMeasurementsView - English", traits: .navEmbedded) {
    RecordingAltitudeMeasurementsView(session: SensorSession.mockSession())
}

#Preview("RecordingAltitudeMeasurementsView - German", traits: .navEmbedded) {
    RecordingAltitudeMeasurementsView(session: SensorSession.mockSession())
        .previewLocalization(.german)
}
