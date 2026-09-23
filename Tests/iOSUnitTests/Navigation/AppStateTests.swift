//
//  AppStateTests.swift
//  Sensor-AppiOSUnitTests
//
//  Created by Volker Schmitt on 15.09.26.
//

import SwiftUI
import Testing

@testable import Sensor_App

/// Every `AppState` here is constructed with `isIphone: false` so `onSizeClassChange(_:)`
/// exercises its regular/compact logic regardless of which simulator/device runs the suite.
@MainActor
final class AppStateTests: BaseTestCase {

    // MARK: - Compact -> Regular

    @Test("Compact to regular preserves a drilled-in Location/Map view")
    func compactToRegularPreservesLocationMap() throws {
        let appState = AppState(isIphone: false)
        appState.selectedTab = .position
        appState.positionStack = [.position(.location), .position(.locationMap)]

        appState.onSizeClassChange(.regular)

        #expect(appState.selectedTab == .location)
        #expect(appState.positionStack == [.position(.locationMap)])
    }

    @Test("Compact to regular with a bare Location drill drops the redundant root push")
    func compactToRegularBareLocationDrill() throws {
        let appState = AppState(isIphone: false)
        appState.selectedTab = .position
        appState.positionStack = [.position(.location)]

        appState.onSizeClassChange(.regular)

        #expect(appState.selectedTab == .location)
        #expect(appState.positionStack == [])
    }

    @Test("Compact to regular on the bare Position hub defaults to Location")
    func compactToRegularPositionHubDefault() throws {
        let appState = AppState(isIphone: false)
        appState.selectedTab = .position
        appState.positionStack = []

        appState.onSizeClassChange(.regular)

        #expect(appState.selectedTab == .location)
        #expect(appState.positionStack == [])
    }

    @Test("Compact to regular on the bare Motion hub defaults to Acceleration")
    func compactToRegularMotionHubDefault() throws {
        let appState = AppState(isIphone: false)
        appState.selectedTab = .motion
        appState.motionStack = []

        appState.onSizeClassChange(.regular)

        #expect(appState.selectedTab == .acceleration)
        #expect(appState.motionStack == [])
    }

    // MARK: - Regular -> Compact

    @Test("Regular to compact preserves a drilled-in Acceleration/Log view")
    func regularToCompactPreservesAccelerationLog() throws {
        let appState = AppState(isIphone: false)
        appState.selectedTab = .acceleration
        appState.motionStack = [.motion(.accelerationLog)]

        appState.onSizeClassChange(.compact)

        #expect(appState.selectedTab == .motion)
        #expect(appState.motionStack == [.motion(.acceleration), .motion(.accelerationLog)])
    }

    @Test("Regular to compact preserves a drilled-in Altitude/Log view")
    func regularToCompactPreservesAltitudeLog() throws {
        let appState = AppState(isIphone: false)
        appState.selectedTab = .altitude
        appState.positionStack = [.position(.altitudeLog)]

        appState.onSizeClassChange(.compact)

        #expect(appState.selectedTab == .position)
        #expect(appState.positionStack == [.position(.altitude), .position(.altitudeLog)])
    }

    // MARK: - Suppression flag lifecycle

    @Test("Suppression flag fires once after a transition that changes the tab")
    func suppressionFlagFiresOnce() throws {
        let appState = AppState(isIphone: false)
        appState.selectedTab = .position
        appState.positionStack = [.position(.location)]

        appState.onSizeClassChange(.regular)

        #expect(appState.consumeSelectedTabChangeSuppression() == true)
        #expect(appState.consumeSelectedTabChangeSuppression() == false)
    }

    @Test("Suppression flag is not set when the tab does not change")
    func suppressionFlagNotSetWithoutTabChange() throws {
        let appState = AppState(isIphone: false)
        appState.selectedTab = .magnetometer

        appState.onSizeClassChange(.regular)

        #expect(appState.consumeSelectedTabChangeSuppression() == false)
    }

    // MARK: - Guarded tabs are left untouched

    @Test(
        "Magnetometer, Settings and Recordings tabs are unaffected by size-class changes",
        arguments: [RootTab.magnetometer, .settings, .recordings]
    )
    func guardedTabsUnaffected(tab: RootTab) throws {
        let appState = AppState(isIphone: false)
        appState.selectedTab = tab
        appState.positionStack = [.position(.location)]
        appState.motionStack = [.motion(.acceleration)]
        appState.magnetometerStack = [.magnetometer(.magnetometerLog)]

        appState.onSizeClassChange(.regular)
        appState.onSizeClassChange(.compact)

        #expect(appState.selectedTab == tab)
        #expect(appState.positionStack == [.position(.location)])
        #expect(appState.motionStack == [.motion(.acceleration)])
        #expect(appState.magnetometerStack == [.magnetometer(.magnetometerLog)])
        #expect(appState.consumeSelectedTabChangeSuppression() == false)
    }
}
