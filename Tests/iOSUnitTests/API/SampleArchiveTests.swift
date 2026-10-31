//
//  SampleArchiveTests.swift
//  Sensor-AppiOSUnitTests
//

import Foundation
import Testing

@testable import Sensor_App_Framework

@MainActor
struct SampleArchiveTests {

    // MARK: - Round trips
    @Test("Motion samples survive a round trip", arguments: [0, 1, 1_000])
    func motionRoundTrip(count: Int) throws {
        let samples = count == 0 ? [] : RecordingTestData.motionModels(count: count)
        #expect(try SampleArchive.samples(of: MotionModel.self, from: SampleArchive.archive(samples)) == samples)
    }

    @Test("Altitude samples survive a round trip", arguments: [0, 1, 1_000])
    func altitudeRoundTrip(count: Int) throws {
        let samples = count == 0 ? [] : RecordingTestData.altitudeModels(count: count)
        #expect(try SampleArchive.samples(of: AltitudeModel.self, from: SampleArchive.archive(samples)) == samples)
    }

    @Test("Location samples survive a round trip", arguments: [0, 1, 1_000])
    func locationRoundTrip(count: Int) throws {
        let samples = count == 0 ? [] : RecordingTestData.locationModels(count: count)
        #expect(try SampleArchive.samples(of: LocationModel.self, from: SampleArchive.archive(samples)) == samples)
    }

    @Test("Special values and locale-formatted timestamps are preserved exactly")
    func specialValues() throws {
        // Timestamps come from a locale-dependent format style, so they can contain non-ASCII digits.
        let values: [Double] = [-1, -0.0, .infinity, -.infinity, .nan, .leastNonzeroMagnitude, 1e300, 0.1 + 0.2]
        let samples = values.enumerated().map { index, value in
            AltitudeModel(
                counter: index - 3, timestamp: "١٢:٣٤:٥٦٫٧٨٩ 🕑", pressureValue: value, relativeAltitudeValue: -value)
        }

        let decoded = try SampleArchive.samples(of: AltitudeModel.self, from: SampleArchive.archive(samples))

        // Compare bit patterns, since -0.0 == 0.0. NaN never equals itself, and JSON stores every NaN
        // as "nan", so its sign is lost (it carries no meaning): any NaN counts as equal.
        func identical(_ lhs: [Double], _ rhs: [Double]) -> Bool {
            zip(lhs, rhs).allSatisfy { ($0.isNaN && $1.isNaN) || $0.bitPattern == $1.bitPattern }
        }
        #expect(identical(decoded.map(\.pressureValue), samples.map(\.pressureValue)))
        #expect(identical(decoded.map(\.relativeAltitudeValue), samples.map(\.relativeAltitudeValue)))
        #expect(decoded.map(\.counter) == samples.map(\.counter))
        #expect(decoded.map(\.timestamp) == samples.map(\.timestamp))
    }

    @Test("Compression makes an archive much smaller than its JSON")
    func archiveIsCompressed() throws {
        let samples = RecordingTestData.motionModels(count: 10_000)
        let archive = try SampleArchive.archive(samples)

        #expect(archive.count < (try JSONEncoder().encode(samples).count) / 2)
    }

    // MARK: - Persisted format
    //
    // Archives written by released app versions must stay readable. These literals pin every key and
    // the strings for non-finite values: if one of these tests fails, a change broke saved recordings.

    @Test("Motion archives use the persisted keys")
    func motionKeys() throws {
        let json = """
            [{"counter":1,"timestamp":"10:15:30","accelerationXAxis":1,"accelerationYAxis":2,
            "accelerationZAxis":3,"gravityXAxis":4,"gravityYAxis":5,"gravityZAxis":6,"gyroXAxis":7,
            "gyroYAxis":8,"gyroZAxis":9,"magnetometerCalibration":2,"magnetometerXAxis":10,
            "magnetometerYAxis":11,"magnetometerZAxis":12,"attitudeRoll":13,"attitudePitch":14,
            "attitudeYaw":15,"attitudeHeading":"nan"}]
            """
        let sample = try #require(SampleArchive.samples(of: MotionModel.self, from: compressed(json)).first)

        #expect(sample.counter == 1)
        #expect(sample.timestamp == "10:15:30")
        #expect(sample.accelerationXAxis == 1)
        #expect(sample.gyroZAxis == 9)
        #expect(sample.magnetometerCalibration == 2)
        #expect(sample.attitudeYaw == 15)
        #expect(sample.attitudeHeading.isNaN)
    }

    @Test("Altitude archives use the persisted keys")
    func altitudeKeys() throws {
        let json = """
            [{"counter":1,"timestamp":"10:15:30","pressureValue":101.3,"relativeAltitudeValue":"-inf"}]
            """
        let samples = try SampleArchive.samples(of: AltitudeModel.self, from: compressed(json))

        #expect(
            samples == [
                AltitudeModel(
                    counter: 1, timestamp: "10:15:30", pressureValue: 101.3, relativeAltitudeValue: -.infinity)
            ])
    }

    @Test("Location archives use the persisted keys")
    func locationKeys() throws {
        let json = """
            [{"counter":1,"longitude":8.68,"latitude":50.11,"altitude":112,"speed":1.5,"course":"inf",
            "horizontalAccuracy":5,"verticalAccuracy":3,"timestamp":"10:15:30","GPSAccuracy":4}]
            """
        let samples = try SampleArchive.samples(of: LocationModel.self, from: compressed(json))

        #expect(
            samples == [
                LocationModel(
                    counter: 1, longitude: 8.68, latitude: 50.11, altitude: 112, speed: 1.5, course: .infinity,
                    horizontalAccuracy: 5, verticalAccuracy: 3, timestamp: "10:15:30", GPSAccuracy: 4)
            ])
    }

    @Test("Keys written by a newer app version are ignored")
    func unknownKeysAreIgnored() throws {
        let json = """
            [{"counter":1,"timestamp":"10:15:30","pressureValue":101.3,"relativeAltitudeValue":0.5,"temperature":21}]
            """

        #expect(try SampleArchive.samples(of: AltitudeModel.self, from: compressed(json)).count == 1)
    }

    // MARK: - Invalid input
    @Test("Decoding an archive of another sensor fails")
    func wrongSensor() throws {
        let archive = try SampleArchive.archive(RecordingTestData.altitudeModels(count: 5))

        #expect(throws: DecodingError.self) { try SampleArchive.samples(of: MotionModel.self, from: archive) }
    }

    @Test("Decoding truncated or garbage data fails instead of crashing")
    func corruptData() throws {
        let json = try JSONEncoder().encode(RecordingTestData.motionModels(count: 50))
        let truncated = try compressed(json.prefix(json.count - 7))

        #expect(throws: (any Error).self) {
            try SampleArchive.samples(of: MotionModel.self, from: Data("garbage".utf8))
        }
        #expect(throws: DecodingError.self) { try SampleArchive.samples(of: MotionModel.self, from: truncated) }
    }

    // MARK: - Helpers
    private func compressed(_ json: String) throws -> Data {
        try compressed(Data(json.utf8))
    }

    private func compressed(_ data: Data) throws -> Data {
        try (data as NSData).compressed(using: .lzfse) as Data
    }
}
