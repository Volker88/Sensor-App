//
//  SampleArchive.swift
//  Sensor-App-Framework
//

import Foundation

/// Compact storage for all samples of one sensor in a recording.
///
/// A session stores one archive per sensor (`SensorSession.motionSampleArchive` etc.) instead of one
/// SwiftData row per sample: the samples are encoded as a JSON array and compressed with LZFSE.
///
/// The JSON keys are the models' `CodingKeys`, so they are a persisted format: archives are stored
/// and synced, and older app versions read archives written by newer ones and vice versa.
/// - **Never rename or remove a key.** Renaming a Swift property is fine as long as its key stays.
/// - **New properties must be optional** (or decoded with `decodeIfPresent` and a default), because
///   archives written before them don't have the key. Unknown keys are ignored when decoding, so older
///   app versions simply skip the new values.
nonisolated enum SampleArchive {

    /// Plain JSON can't represent NaN or ±infinity, and `JSONEncoder` throws on them by default, which
    /// would make the whole save fail. CoreMotion and Core Location mark invalid values with negative
    /// numbers, not NaN, so this is a safety net: one unexpected value is stored as a string instead of
    /// losing the recording. Never change these strings: existing archives may contain them.
    private static let positiveInfinity = "inf"
    private static let negativeInfinity = "-inf"
    private static let notANumber = "nan"

    /// Encodes the samples into a compressed archive.
    static func archive<Sample: Encodable>(_ samples: [Sample]) throws -> Data {
        let encoder = JSONEncoder()
        encoder.nonConformingFloatEncodingStrategy = .convertToString(
            positiveInfinity: positiveInfinity, negativeInfinity: negativeInfinity, nan: notANumber
        )
        let json = try encoder.encode(samples)
        return try (json as NSData).compressed(using: .lzfse) as Data
    }

    /// Decodes an archive written by `archive(_:)`.
    /// - Throws: An error if the archive isn't valid compressed JSON, or a sample lacks a required key
    ///   (for example because the archive belongs to another sensor).
    static func samples<Sample: Decodable>(of type: Sample.Type, from archive: Data) throws -> [Sample] {
        let json = try (archive as NSData).decompressed(using: .lzfse) as Data
        let decoder = JSONDecoder()
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: positiveInfinity, negativeInfinity: negativeInfinity, nan: notANumber
        )
        return try decoder.decode([Sample].self, from: json)
    }
}
