//
//  NavigationLayoutTests.swift
//  Sensor-AppiOSUnitTests
//
//  Created by Volker Schmitt on 10.10.26.
//

import SwiftUI
import Testing

@testable import Sensor_App

/// The layout rule is a pure function of its inputs, so these tests behave the same on any
/// simulator/device.
@MainActor
struct NavigationLayoutTests {

    @Test("iPad with room in both directions gets the flat layout")
    func padWithRoomUsesFlatLayout() {
        #expect(
            !NavigationLayout.usesCompactLayout(
                horizontalSizeClass: .regular, verticalSizeClass: .regular, isPhone: false))
    }

    @Test("iPad in a narrow window gets the compact layout")
    func padInNarrowWindowUsesCompactLayout() {
        #expect(
            NavigationLayout.usesCompactLayout(
                horizontalSizeClass: .compact, verticalSizeClass: .regular, isPhone: false))
    }

    @Test("iPad in a short window gets the compact layout")
    func padInShortWindowUsesCompactLayout() {
        #expect(
            NavigationLayout.usesCompactLayout(
                horizontalSizeClass: .regular, verticalSizeClass: .compact, isPhone: false))
    }

    @Test("A phone reporting regular size classes, like an unfolded Duo, stays compact")
    func phoneWithRegularSizeClassesUsesCompactLayout() {
        #expect(
            NavigationLayout.usesCompactLayout(
                horizontalSizeClass: .regular, verticalSizeClass: .regular, isPhone: true))
    }

    @Test("A phone in landscape with a regular width stays compact")
    func phoneInLandscapeUsesCompactLayout() {
        #expect(
            NavigationLayout.usesCompactLayout(
                horizontalSizeClass: .regular, verticalSizeClass: .compact, isPhone: true))
    }

    @Test("A missing size class falls back to the compact layout")
    func missingSizeClassUsesCompactLayout() {
        #expect(NavigationLayout.usesCompactLayout(horizontalSizeClass: nil, verticalSizeClass: nil, isPhone: false))
    }
}
