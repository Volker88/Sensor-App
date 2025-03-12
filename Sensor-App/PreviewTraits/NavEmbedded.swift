//
//  NavEmbedded.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11/24/24.
//

import Sensor_App_Framework
import SwiftUI

struct NavEmbedded: PreviewModifier {
    func body(content: Content, context: Void) -> some View {
        NavigationStack {
            content
                #if !os(watchOS)
                    .environment(AppState())
                #endif
                .environment(SettingsManager())
                .environment(CalculationManager())
                .environment(MotionManager())
                .environment(LocationManager())
        }
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    static var navEmbedded: Self = .modifier(NavEmbedded())
}
