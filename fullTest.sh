#!/bin/bash

#xcrun simctl list devices

# Define Simulator UUIDs
iPhone="CFFBE3CE-1571-4A62-801A-BCA93928F038"
iPhoneDuo="B9F29D90-AAB7-4221-9417-456096ED12AB"
iPad="B1897AE0-DE31-40C3-B26D-9DCE360BA564"

# Define the OS version in a variable
OS_VERSION="27.1"

# Define Appearance light / dark
APPEARANCE="light"

xcrun simctl boot $iPhone
xcrun simctl boot $iPhoneDuo
xcrun simctl boot $iPad

xcrun simctl status_bar $iPhone override --time "9:41"
xcrun simctl status_bar $iPhoneDuo override --time "9:41"
xcrun simctl status_bar $iPad override --time "9:41"

xcrun simctl ui $iPhone appearance $APPEARANCE
xcrun simctl ui $iPhoneDuo appearance $APPEARANCE
xcrun simctl ui $iPad appearance $APPEARANCE


#xcodebuild clean -project 'Sensor-App.xcodeproj'


# Run xcodebuild with the OS version variable
xcodebuild test -testPlan iOS_FullTest -project 'Sensor-App.xcodeproj' -scheme 'Sensor-App' \
-destination "platform=iOS Simulator,name=iPhone 18 Pro Max,OS=$OS_VERSION" \
-destination "platform=iOS Simulator,name=iPhone Duo,OS=$OS_VERSION" \
-destination "platform=iOS Simulator,name=iPad Pro 13-inch (M5) (16GB),OS=$OS_VERSION" \
-parallel-testing-enabled YES \
-derivedDataPath '/tmp/SensorappDerivedData/'

cd /tmp/SensorappDerivedData
open .


# xcparse screenshots --os --model --test-plan-config test.xcresult ~/Desktop --legacy
