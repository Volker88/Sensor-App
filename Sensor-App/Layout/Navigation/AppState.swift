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
    ///
    /// Uses the shared ``NavigationRoute`` element type (rather than `[PositionStack]`) so that
    /// every tab's `NavigationStack` shares one path type. See ``NavigationRoute``.
    var positionStack: [NavigationRoute] = []

    /// Stack for all Motion Screens
    ///
    /// Uses the shared ``NavigationRoute`` element type (rather than `[MotionStack]`) so that
    /// every tab's `NavigationStack` shares one path type. See ``NavigationRoute``.
    var motionStack: [NavigationRoute] = []

    /// Stack for Magnetometer Screens
    ///
    /// Uses the shared ``NavigationRoute`` element type (rather than `[MagnetometerStack]`) so that
    /// every tab's `NavigationStack` shares one path type. See ``NavigationRoute``.
    var magnetometerStack: [NavigationRoute] = []

    /// Stack for Recordings Screens
    ///
    /// Uses the shared ``NavigationRoute`` element type (rather than `[RecordingsStack]`) so that
    /// every tab's `NavigationStack` shares one path type. See ``NavigationRoute``.
    var recordingsStack: [NavigationRoute] = []

    /// The chart currently presented full screen via `ExpandableChartView`, if any.
    ///
    /// Lives here rather than as local `@State` on each `*View` because a size-class change
    /// swaps out the entire compact/regular branch of `ContentView`'s `TabView`, tearing down
    /// and recreating the presenting view (and any local `@State` it held) even when the
    /// underlying screen is conceptually unchanged. Presenting from `ContentView` itself, which
    /// survives that swap, keeps the full-screen chart open across the transition.
    var selectedChart: ChartSelection?

    /// Set immediately before ``onSizeClassChange(_:)`` reassigns ``selectedTab``, so the
    /// resulting `ContentView.onChange(of: selectedTab)` can skip its stop/reset side effects
    /// for a layout-driven tab change, as opposed to a genuine user-initiated tab switch.
    @ObservationIgnored
    private var suppressNextSelectedTabChange = false

    /// Reset all Stacks
    func resetStack() {
        positionStack.removeAll()
        motionStack.removeAll()
        magnetometerStack.removeAll()
        recordingsStack.removeAll()
    }

    /// Consumes (and clears) the size-class-change suppression flag. Called once from
    /// `ContentView.onChangeOfSelectedTab()`.
    func consumeSelectedTabChangeSuppression() -> Bool {
        guard suppressNextSelectedTabChange else { return false }
        suppressNextSelectedTabChange = false
        return true
    }

    // MARK: - Update Navigation
    /// Update Navigation when Size Class changes
    ///
    /// Compact layout nests granular screens under an umbrella tab (``RootTab/position``,
    /// ``RootTab/motion``), pushing the granular screen as the first path entry followed by
    /// however many detail screens are drilled into. Regular layout gives the granular screen
    /// its own tab instead, so that first path entry is implicit in the tab selection and the
    /// remaining entries (however many there are) carry over unchanged.
    func onSizeClassChange(_ newSize: UserInterfaceSizeClass?) {
        // If the device is an iPhone, we do not need to update the navigation
        guard !isIphone else { return }

        // If the selectedTab is Magnetometer, Settings or Recordings, we do not need to update the navigation
        // Those tabs are not affected by size class changes and should remain as they are
        guard selectedTab != .magnetometer && selectedTab != .settings && selectedTab != .recordings else { return }

        var newTab = selectedTab

        if newSize == .regular {
            switch selectedTab {
                case .position:
                    newTab = positionStack.first?.rootTab ?? .location
                    positionStack = Array(positionStack.dropFirst())
                case .motion:
                    newTab = motionStack.first?.rootTab ?? .acceleration
                    motionStack = Array(motionStack.dropFirst())
                default: break
            }
        } else if newSize == .compact, let parent = selectedTab.compactParent {
            newTab = parent
            if let root = selectedTab.positionStackRoot {
                positionStack.insert(root, at: 0)
            } else if let root = selectedTab.motionStackRoot {
                motionStack.insert(root, at: 0)
            }
        }

        if newTab != selectedTab {
            suppressNextSelectedTabChange = true
            selectedTab = newTab
        }
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
                case .recordings:
                    selectedTab = .recordings
                default:
                    break
            }

            Task { [appIntentTab] in
                try? await Task.sleep(for: .seconds(0.5))
                switch appIntentTab {
                    case .location:
                        positionStack = [.position(.location)]
                    case .altitude:
                        positionStack = [.position(.altitude)]
                    case .acceleration:
                        motionStack = [.motion(.acceleration)]
                    case .gravity:
                        motionStack = [.motion(.gravity)]
                    case .gyroscope:
                        motionStack = [.motion(.gyroscope)]
                    case .attitude:
                        motionStack = [.motion(.attitude)]
                    default:
                        break
                }
            }
        }

    }

    // MARK: - Shortcut
    func updateShortcutParameter() {
        SensorAppShortcuts.updateAppShortcutParameters()
    }
}
