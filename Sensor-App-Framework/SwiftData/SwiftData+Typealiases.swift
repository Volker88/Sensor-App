//
//  SwiftData+Typealiases.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import Foundation

/// Points to the active schema so a single change here updates all consumers
/// when the schema is bumped to a new version.
public typealias LatestModelSchema = ModelsSchemaV1

/// The root recording entity grouping all sensor measurements for one session.
public typealias SensorSession = LatestModelSchema.SensorSession

/// A single Core Motion sample (acceleration, gravity, gyroscope, magnetometer,
/// attitude).
public typealias MotionMeasurement = LatestModelSchema.MotionMeasurement

/// A single barometric pressure and relative-altitude sample from `CMAltimeter`.
public typealias AltitudeMeasurement = LatestModelSchema.AltitudeMeasurement

/// A single GPS / location sample from `CLLocationManager`.
public typealias LocationMeasurement = LatestModelSchema.LocationMeasurement
