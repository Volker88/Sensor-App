//
//  SettingsOverlay.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.08.20.
//

// MARK: - Import
import SwiftUI

// MARK: - Struct / Class Definition
struct SettingsOverlay: View {

    // MARK: - @State / @ObservedObject / @Binding
    @State private var showSettings = false

    // MARK: - Body
    var body: some View {
        Button(action: {
            showSettings.toggle()
        }) {
            Label(NSLocalizedString("Settings", comment: "Settings"), systemImage: "gear")
                .padding(10)
        }
        .accessibilityIdentifier("Settings")
        // .hoverEffect()
        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
        .background((Color.gray).opacity(0.3))
        .sheet(isPresented: $showSettings) {
            SettingsScreen()
        }
    }
}

// MARK: - Preview
struct SettingsOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            SettingsOverlay()
                .previewLayout(.sizeThatFits)
                .colorScheme(scheme)
        }
    }
}
