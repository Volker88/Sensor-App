//
//  RecordingMotionMeasurementsView.swift
//  Sensor-App
//

import Sensor_App_Framework
import SwiftData
import SwiftUI

struct RecordingMotionMeasurementsView: View {

    let session: SensorSession

    private var sorted: [MotionMeasurement] {
        (session.motionMeasurements ?? []).sorted { $0.counter < $1.counter }
    }

    // MARK: - Body
    var body: some View {
        List(sorted) { measurement in
            DisclosureGroup {
                Group {
                    LabeledContent(
                        "Acc X", value: measurement.accelerationXAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Acc Y", value: measurement.accelerationYAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Acc Z", value: measurement.accelerationZAxis.formatted(.number.precision(.fractionLength(5))))

                }
                Group {
                    LabeledContent(
                        "Gravity X", value: measurement.gravityXAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Gravity Y", value: measurement.gravityYAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Gravity Z", value: measurement.gravityZAxis.formatted(.number.precision(.fractionLength(5))))

                }
                Group {
                    LabeledContent(
                        "Gyro X", value: measurement.gyroXAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Gyro Y", value: measurement.gyroYAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Gyro Z", value: measurement.gyroZAxis.formatted(.number.precision(.fractionLength(5))))

                }
                Group {
                    LabeledContent("Mag Cal", value: measurement.magnetometerCalibration.formatted())

                    LabeledContent(
                        "Mag X", value: measurement.magnetometerXAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Mag Y", value: measurement.magnetometerYAxis.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Mag Z", value: measurement.magnetometerZAxis.formatted(.number.precision(.fractionLength(5))))

                }
                Group {
                    LabeledContent(
                        "Roll (°)",
                        value: measurement.attitudeRollDegrees.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Pitch (°)",
                        value: measurement.attitudePitchDegrees.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Yaw (°)",
                        value: measurement.attitudeYawDegrees.formatted(.number.precision(.fractionLength(5))))

                    LabeledContent(
                        "Heading (°)",
                        value: measurement.attitudeHeading.formatted(.number.precision(.fractionLength(5))))
                }
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
