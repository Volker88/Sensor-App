//
//  CustomControlsView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.06.25.
//

import Sensor_App_Framework
import SwiftUI

struct CustomControlsView: View {

    @Environment(\.showNotification) private var showNotification
    @Environment(LocationManager.self) private var locationManager
    @Environment(MotionManager.self) private var motionManager
    @Environment(RecordingManager.self) private var recordingManager
    @Environment(SettingsManager.self) private var settingsManager

    @State private var isExpanded = false
    @Namespace var glassEffect

    // MARK: - Body
    var body: some View {
        HStack {
            Spacer()

            GlassEffectContainer {
                ZStack {
                    Group {
                        button(type: .start)
                        button(type: .pause)
                        button(type: .delete)
                        button(type: .record)
                    }
                    .accessibilityElement(children: .contain)

                    Button {
                        toggleButton()
                    } label: {
                        Image(systemName: "ellipsis")
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                    }
                    .accessibilityLabel(Text(isExpanded ? "Collapse" : "Expand"))
                    .accessibilityHint(Text("Tap to expand or collapse the control menu"))
                    .accessibilityIdentifier(UIIdentifiers.CustomControlsView.expandButton)
                    .glassEffect(.regular.tint(.white.opacity(0.8)).interactive())
                    .glassEffectID("menu", in: glassEffect)
                }
            }
            .padding([.trailing, .bottom], 25)
        }
    }

    // MARK: - Methods
    private func button(type: SensorControlAction) -> some View {
        let isRecordActive = type == .record && recordingManager.isRecording
        // Only Record (Stop) stays usable mid-recording: starting, pausing or deleting
        // would leave gaps in (or wipe) the session's data. While the stopped session is
        // still being saved, nothing can be used, so a new recording can't start yet.
        let isDisabled = (type != .record && recordingManager.isRecording) || recordingManager.isSaving
        return Button {
            switch type {
                case .start:
                    showNotification("Started")
                    locationManager.startLocationUpdates()
                    motionManager.startMotionUpdates()
                    motionManager.startAltitudeUpdates()
                case .pause:
                    showNotification("Paused")
                    locationManager.stopLocationUpdates()
                    motionManager.stopMotionUpdates()
                case .delete:
                    showNotification("Deleted")
                    locationManager.resetLocationUpdates()
                    motionManager.resetMotionUpdates()
                case .record:
                    recording()
            }
        } label: {
            Label(type.localizedString, systemImage: isRecordActive ? "stop.circle.fill" : type.systemImage)
                .labelStyle(.iconOnly)
                .frame(width: 50, height: 50)
                .foregroundStyle(foregroundColor(type: type, isRecordActive: isRecordActive, isDisabled: isDisabled))
        }
        .disabled(isDisabled)
        .opacity(isExpanded ? 1 : 0)
        // Explicit foreground colors override SwiftUI's automatic disabled dimming, and
        // interactive glass keeps reacting to touches, so reflect the state manually.
        .glassEffect(.regular.tint(.white.opacity(0.8)).interactive(!isDisabled))
        .glassEffectID(type.rawValue, in: glassEffect)
        .offset(type.offset(expanded: isExpanded))
        .animation(.spring(duration: 0.3, bounce: 0.3), value: isExpanded)
        .accessibilityHidden(!isExpanded)
        .accessibilityLabel(Text(type.localizedString))
        .accessibilityHint(Text(accessibilityHint(type: type, isRecordActive: isRecordActive, isDisabled: isDisabled)))
        .accessibilityIdentifier(type.accessibilityIdentifier)
    }

    private func foregroundColor(type: SensorControlAction, isRecordActive: Bool, isDisabled: Bool) -> Color {
        if isDisabled {
            return .secondary
        }
        return type == .delete || isRecordActive ? .red : .primary
    }

    private func accessibilityHint(
        type: SensorControlAction,
        isRecordActive: Bool,
        isDisabled: Bool
    ) -> LocalizedStringKey {
        if isDisabled {
            return recordingManager.isSaving
                ? LocalizedStringKey("Unavailable while saving")
                : LocalizedStringKey("Unavailable while recording")
        }
        return isRecordActive ? LocalizedStringKey("Tap to stop recording") : type.accessibilityHint
    }

    private func toggleButton() {
        withAnimation {
            isExpanded.toggle()
        }
    }

    private func recording() {
        if recordingManager.isRecording {
            Task {
                let saved = await recordingController.stop()
                showNotification(saved ? "Recording Saved" : "Recording Could Not Be Saved")
            }
            // Only announce the save if it takes noticeable time, so short sessions don't flash
            // two toasts in a row.
            Task {
                try? await Task.sleep(for: .milliseconds(500))
                if recordingManager.isSaving {
                    showNotification("Saving…")
                }
            }
        } else {
            recordingController.start()
            showNotification("Recording Started")
        }
    }

    private var recordingController: RecordingController {
        RecordingController(
            recordingManager: recordingManager,
            motionManager: motionManager,
            locationManager: locationManager,
            settingsManager: settingsManager
        )
    }
}

// MARK: - Preview
#Preview("CustomControlsView - English", traits: .navEmbedded) {
    VStack {
        Spacer()
        CustomControlsView()
    }
    .environment(LocationManager())
    .environment(MotionManager())
    .environment(RecordingManager())
}

#Preview("CustomControlsView - German", traits: .navEmbedded) {
    VStack {
        Spacer()
        CustomControlsView()
    }
    .previewLocalization(.german)
    .environment(LocationManager())
    .environment(MotionManager())
    .environment(RecordingManager())
}
