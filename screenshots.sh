#!/bin/bash

#xcrun simctl list devices

# Define Simulator UUIDs
iPhone="DE2C1867-6249-49CF-87F3-CB82BE474A0C"
iPad="2FFCF351-B301-47D6-BA11-416AE749E52C"

# Define the OS version in a variable
OS_VERSION="26.0"

# Define Appearance light / dark
APPEARANCE="light"

xcrun simctl boot $iPhone
xcrun simctl boot $iPad

xcrun simctl status_bar $iPhone override --time "9:41"
xcrun simctl status_bar $iPad override --time "9:41"

xcrun simctl ui $iPhone appearance $APPEARANCE
xcrun simctl ui $iPad appearance $APPEARANCE

#xcodebuild clean -project 'Print Commander.xcodeproj'


# Run xcodebuild with the OS version variable
xcodebuild test -testPlan iOS_ScreenshotTest -project 'Sensor-App.xcodeproj' -scheme 'Sensor-App' \
-destination "platform=iOS Simulator,name=iPhone 16 Pro Max,OS=$OS_VERSION" \
-destination "platform=iOS Simulator,name=iPad Pro 13-inch (M4),OS=$OS_VERSION" \
-parallel-testing-enabled YES \
-derivedDataPath '/tmp/SensorappDerivedData/'

cd /tmp/SensorappDerivedData
open .


# xcparse screenshots --os --model --test-plan-config test.xcresult ~/Desktop --legacy
