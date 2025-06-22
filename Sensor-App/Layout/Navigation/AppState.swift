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
    func onSizeClassChange() {
        selectedTab = .location
        resetStack()
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
