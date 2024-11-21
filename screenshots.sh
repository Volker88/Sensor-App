#!/bin/bash

#xcrun simctl list devices

# Define Simulator UUIDs
iPhone="2A48624C-7026-42E8-8C4E-18E120D93492"
iPad="3775D7AE-4C08-4B16-B320-0115FC021B24"

# Define the OS version in a variable
OS_VERSION="18.1"

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
-derivedDataPath '/tmp/PrintCommanderDerivedData/'

cd /tmp/PrintCommanderDerivedData
open .


# xcparse screenshots --os --model --test-plan-config test.xcresult ~/Desktop --legacy
