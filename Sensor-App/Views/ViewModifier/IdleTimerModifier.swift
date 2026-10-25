//
//  IdleTimerModifier.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 25.10.26.
//

import SwiftUI

// MARK: - Keeps the device from auto-locking while active
/// Mirrors `isDisabled` into `UIApplication.shared.isIdleTimerDisabled`.
///
/// Because it is driven by a value rather than by start/stop calls, the flag is reset
/// whenever the value turns `false`, no matter how a recording ends (stop, failed save, …).
/// It is also reset when the view leaves the hierarchy, so a closed scene can't leave the
/// screen awake.
struct IdleTimerModifier: ViewModifier {

    let isDisabled: Bool

    func body(content: Content) -> some View {
        content
            .onChange(of: isDisabled, initial: true) {
                UIApplication.shared.isIdleTimerDisabled = isDisabled
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
    }
}

// MARK: - Extension
extension View {
    func idleTimerDisabled(_ isDisabled: Bool) -> some View {
        self.modifier(IdleTimerModifier(isDisabled: isDisabled))
    }
}
