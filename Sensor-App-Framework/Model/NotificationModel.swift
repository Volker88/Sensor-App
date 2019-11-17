//
//  NotificationModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 28.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import Foundation
import SwiftUI


// MARK: - Struct Definition
struct NotificationAnimationModel {
    let offSetY: CGFloat
    let springMass: Double
    let springStiffness: Double
    let springDamping: Double
    let springVelocity: Double
    let duration: Double
}
