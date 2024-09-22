#!/bin/bash

#xcrun simctl list devices

# Define Simulator UUIDs
iPhone="1A8A8C86-E8D1-43C8-87CF-5152B0AB07CC"
iPad="CD2328A6-2694-435A-A7A5-0FF72C7A57FA"

# Define the OS version in a variable
OS_VERSION="18.0"

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
xcodebuild test -testPlan ScreenshotTest -project 'Sensor-App.xcodeproj' -scheme 'Sensor-App' \
-destination "platform=iOS Simulator,name=iPhone 16 Pro Max,OS=$OS_VERSION" \
-destination "platform=iOS Simulator,name=iPad Pro 13-inch (M4),OS=$OS_VERSION" \
-parallel-testing-enabled YES \
-derivedDataPath '/tmp/PrintCommanderDerivedData/'

cd /tmp/PrintCommanderDerivedData
open .
