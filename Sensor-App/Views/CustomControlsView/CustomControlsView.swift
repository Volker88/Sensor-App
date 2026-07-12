//
//  CustomControlsView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.06.25.
//

import Sensor_App_Framework
import SwiftUI
import UIKit

struct CustomControlsView: View {

    @Environment(\.showNotification) private var showNotification
    @Environment(LocationManager.self) private var locationManager
    @Environment(MotionManager.self) private var motionManager
    @Environment(RecordingManager.self) private var recordingManager

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
    private func button(type: ButtonType) -> some View {
        let isRecordActive = type == .record && recordingManager.isRecording
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
                    if recordingManager.isRecording {
                        recordingManager.stopRecording(
                            motionArray: motionManager.motionArray,
                            altitudeArray: motionManager.altitudeArray,
                            locationArray: locationManager.locationArray,
                            source: UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
                        )
                        showNotification("Recording Saved")
                    } else {
                        recordingManager.startRecording()
                        showNotification("Recording Started")
                    }
            }
        } label: {
            Label(type.localizedString, systemImage: isRecordActive ? "stop.circle.fill" : type.systemImage)
                .labelStyle(.iconOnly)
                .frame(width: 50, height: 50)
                .foregroundStyle(type == .delete || isRecordActive ? Color.red : Color.primary)
        }
        .opacity(isExpanded ? 1 : 0)
        .glassEffect(.regular.tint(.white.opacity(0.8)).interactive())
        .glassEffectID(type.rawValue, in: glassEffect)
        .offset(type.offset(expanded: isExpanded))
        .animation(.spring(duration: 0.3, bounce: 0.3), value: isExpanded)
        .accessibilityHidden(!isExpanded)
        .accessibilityLabel(Text(type.localizedString))
        .accessibilityHint(Text(isRecordActive ? LocalizedStringKey("Tap to stop recording") : type.accessibilityHint))
        .accessibilityIdentifier(type.accessibilityIdentifier)
    }

    private func toggleButton() {
        withAnimation {
            isExpanded.toggle()
        }
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
