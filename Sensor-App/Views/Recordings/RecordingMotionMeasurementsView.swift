//
//  RecordingMotionMeasurementsView.swift
//  Sensor-App
//

import Sensor_App_Framework
import SwiftData
import SwiftUI

struct RecordingMotionMeasurementsView: View {

    let session: SensorSession

    // MARK: - Body
    var body: some View {
        RecordingSampleList(load: { try await session.loadMotionSamples() }, id: \.counter) { sample in
            DisclosureGroup {
                Group {
                    LabeledContent(
                        "Acc X", value: sample.accelerationXAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Acc Y", value: sample.accelerationYAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Acc Z", value: sample.accelerationZAxis.formatted(.number.precision(.fractionLength(5))))

                }
                Group {
                    LabeledContent(
                        "Gravity X", value: sample.gravityXAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Gravity Y", value: sample.gravityYAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Gravity Z", value: sample.gravityZAxis.formatted(.number.precision(.fractionLength(5))))

                }
                Group {
                    LabeledContent(
                        "Gyro X", value: sample.gyroXAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Gyro Y", value: sample.gyroYAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Gyro Z", value: sample.gyroZAxis.formatted(.number.precision(.fractionLength(5))))

                }
                Group {
                    LabeledContent("Mag Cal", value: sample.magnetometerCalibration.formatted())

                    LabeledContent(
                        "Mag X", value: sample.magnetometerXAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Mag Y", value: sample.magnetometerYAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Mag Z", value: sample.magnetometerZAxis.formatted(.number.precision(.fractionLength(5))))

                }
                Group {
                    LabeledContent(
                        "Roll (°)",
                        value: sample.graphValue(for: .attitudeRoll).formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Pitch (°)",
                        value: sample.graphValue(for: .attitudePitch).formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Yaw (°)",
                        value: sample.graphValue(for: .attitudeYaw).formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Heading (°)",
                        value: sample.attitudeHeading.formatted(.number.precision(.fractionLength(5))))
                }
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
        .navigationTitle("Motion Measurements")
    }
}

// MARK: - Preview
#Preview("RecordingMotionMeasurementsView - English", traits: .navEmbedded) {
    RecordingMotionMeasurementsView(session: SensorSession.mockSession())
}

#Preview("RecordingMotionMeasurementsView - German", traits: .navEmbedded) {
    RecordingMotionMeasurementsView(session: SensorSession.mockSession())
        .previewLocalization(.german)
}
