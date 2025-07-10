//
//  AppState.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import AppIntents
import SwiftUI

@MainActor
@Observable
final class AppState {

    #if os(iOS)
        var isIphone: Bool {
            UIDevice.current.userInterfaceIdiom == .phone
        }
    #else
        let isIphone = false
    #endif

    /// Root tab selection for TabView Navigation
    var selectedTab: RootTab = .position

    /// Tab used for App Intent driven Navigation
    var appIntentTab: RootTab?

    // MARK: - Navigation Stacks
    /// Stack for all Position Screens
    var positionStack: [PositionStack] = []

    /// Stack for all Motion Screens
    var motionStack: [MotionStack] = []

    /// Stack for Magnetometer Screens
    var magnetometerStack: [MagnetometerStack] = []

    /// Reset all Stacks
    func resetStack() {
        positionStack.removeAll()
        motionStack.removeAll()
        magnetometerStack.removeAll()
    }

    // MARK: - Update Navigation
    /// Update Navigation when Size Class changes
    func onSizeClassChange(_ newSize: UserInterfaceSizeClass?) { // wiftlint:disable:this cyclomatic_complexity
        // If the device is an iPhone, we do not need to update the navigation
        guard !isIphone, let newSize else { return }

        // If the selectedTab is Magnetometer or Settings, we do not need to update the navigation
        guard selectedTab != .magnetometer && selectedTab != .settings else { return }

//        let prevMotionStack = self.motionStack
//        let prevPositionStack = self.positionStack

        resetStack()
        selectedTab = .position

//        if newSize == .regular {
//            // Position Stack
//            if prevPositionStack.contains(.location) {
//                selectedTab = .location
//            } else if prevPositionStack.contains(.altitude) {
//                selectedTab = .altitude
//            }
//
//            if prevPositionStack.contains(.locationMap) {
//                positionStack = [.locationMap]
//            } else if prevPositionStack.contains(.altitudeLog) {
//                positionStack = [.altitudeLog]
//            }
//
//            // Motion Stack
//            if prevMotionStack.contains(.acceleration) {
//                selectedTab = .acceleration
//            } else if prevMotionStack.contains(.gravity) {
//                selectedTab = .gravity
//            } else if prevMotionStack.contains(.gyroscope) {
//                selectedTab = .gyroscope
//            } else if prevMotionStack.contains(.attitude) {
//                selectedTab = .attitude
//            }
//
//            if prevMotionStack.contains(.accelerationLog) {
//                motionStack = [.accelerationLog]
//            } else if prevMotionStack.contains(.gravityLog) {
//                motionStack = [.gravityLog]
//            } else if prevMotionStack.contains(.gyroscopeLog) {
//                motionStack = [.gyroscopeLog]
//            } else if prevMotionStack.contains(.attitudeLog) {
//                motionStack = [.attitudeLog]
//            }
//        } else if newSize == .compact {
//            switch selectedTab {
//                case .location:
//                    selectedTab = .position
//                    positionStack = [.location]
//                    if prevPositionStack.contains(.locationMap) {
//                        positionStack.append(.locationMap)
//                    }
//                case .altitude:
//                    selectedTab = .position
//                    positionStack = [.altitude]
//                    if prevPositionStack.contains(.altitudeLog) {
//                        positionStack.append(.altitudeLog)
//                    }
//                case .acceleration:
//                    selectedTab = .motion
//                    motionStack = [.acceleration]
//                    if prevMotionStack.contains(.accelerationLog) {
//                        motionStack.append(.accelerationLog)
//                    }
//                case .gravity:
//                    selectedTab = .motion
//                    motionStack = [.gravity]
//                    if prevMotionStack.contains(.gravityLog) {
//                        motionStack.append(.gravityLog)
//                    }
//                case .gyroscope:
//                    selectedTab = .motion
//                    motionStack = [.gyroscope]
//                    if prevMotionStack.contains(.gyroscopeLog) {
//                        motionStack.append(.gyroscopeLog)
//                    }
//                case .attitude:
//                    selectedTab = .motion
//                    motionStack = [.attitude]
//                    if prevMotionStack.contains(.attitudeLog) {
//                        motionStack.append(.attitudeLog)
//                    }
//                default: break
//            }
//        }
//
//        print("Previous MotionStack: \(prevMotionStack)")
//        print("Previous PositionStack: \(prevPositionStack)")
//
//        print("MotionStck: \(motionStack)")
//        print("PositionStack: \(positionStack)")
    }

    /// Perform Navigation triggered by App Intent
    ///
    /// Depending on the current sizeClass, the navigation will select the ``selectedTab`` and ``positionStack``, ``motionStack``, ``magnetometerStack``
    ///  and reset ``appIntentTab`` to ``nil``
    ///
    /// - Parameter sizeClass: `` UserInterfaceSizeClass``
    func appIntentDrivenNavigation(_ sizeClass: UserInterfaceSizeClass?) {  // swiftlint:disable:this cyclomatic_complexity
        guard let appIntentTab, let sizeClass else { return }

        defer {
            self.appIntentTab = nil
        }

        if sizeClass == .regular {
            selectedTab = appIntentTab
        } else {
            switch appIntentTab {
                case .location, .altitude:
                    selectedTab = .position
                case .acceleration, .gravity, .gyroscope, .attitude:
                    selectedTab = .motion
                case .magnetometer:
                    selectedTab = .magnetometer
                default:
                    break
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                switch appIntentTab {
                    case .location:
                        positionStack = [.location]
                    case .altitude:
                        positionStack = [.altitude]
                    case .acceleration:
                        motionStack = [.acceleration]
                    case .gravity:
                        motionStack = [.gravity]
                    case .gyroscope:
                        motionStack = [.gyroscope]
                    case .attitude:
                        motionStack = [.attitude]
                    default:
                        break
                }
            }
        }

    }

    // MARK: - Shortcut
    func updateShortcutParameter() {
        SensorAppShortchuts.updateAppShortcutParameters()
    }
}
