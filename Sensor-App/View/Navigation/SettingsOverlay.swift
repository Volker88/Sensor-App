//
//  SettingsOverlay.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.08.20.
//

import SwiftUI

struct SettingsOverlay: View {
    @State private var showSettings = false

    var body: some View {
        Button(action: {
            showSettings.toggle()
        }) {
            Label(NSLocalizedString("Settings", comment: "Settings"), systemImage: "gear")
                .padding(10)
        }
        .accessibilityIdentifier("Settings")
        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
        .background((Color.gray).opacity(0.3))
        .sheet(isPresented: $showSettings) {
            SettingsScreen()
        }
    }
}

struct SettingsOverlay_Previews: PreviewProvider {
    static var previews: some View {
        SettingsOverlay()
            .previewLayout(.sizeThatFits)
    }
}
