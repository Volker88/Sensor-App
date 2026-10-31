//
//  RecordingAltitudeMeasurementsView.swift
//  Sensor-App
//

import Sensor_App_Framework
import SwiftData
import SwiftUI

struct RecordingAltitudeMeasurementsView: View {

    let session: SensorSession

    // MARK: - Body
    var body: some View {
        RecordingSampleList(load: { try await session.loadAltitudeSamples() }, id: \.counter) { sample in
            DisclosureGroup {
                LabeledContent(
                    "Pressure (\(sample.pressureUnit))",
                    value: sample.calculatedPressure.formatted(.number.precision(.fractionLength(5))))

                LabeledContent(
                    "Rel. Altitude (\(sample.altitudeUnit))",
                    value: sample.calculatedAltitude.formatted(.number.precision(.fractionLength(5))))
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
