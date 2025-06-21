//
//  BaseTestCase.swift
//  Sensor-AppiOSUITests
//
//  Created by Volker Schmitt on 21.03.21.
//

import XCTest

@MainActor
class BaseTestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing", "disable-animations"]
        app.launch()

        // Clear User Defaults
        // swiftlint:disable:next force_unwrapping
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()

        #if os(iOS)
            if isIPad() {
                XCUIDevice.shared.orientation = .landscapeLeft
            } else if isIPhone() {
                XCUIDevice.shared.orientation = .portrait
            }
        #endif

    }

    override func tearDown() async throws {
    }

    // MARK: - Methods
    func isIPad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else {
            return false
        }
    }

    func isIPhone() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return true
        } else {
            return false
        }
    }

    func backToHomeMenu() {
        if isIPhone() {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
    }

    func dismissShareSheet() {
        //        if isIPhone() {
        //            let activityListView = app.otherElements.element(
        //                matching: .other,
        //                identifier: "ActivityListView")

        //            XCTAssertTrue(activityListView.waitForExistence(timeout: 2.0))

        //            activityListView.buttons.element(boundBy: 0).tap()
        //        } else {
        app.otherElements["PopoverDismissRegion"].tap()
        //        }
    }
}
