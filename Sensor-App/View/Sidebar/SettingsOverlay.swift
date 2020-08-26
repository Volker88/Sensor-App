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
    
    // MARK: - Body
    var body: some View {
        NavigationLink(destination: SettingsView()) {
            Label(NSLocalizedString("Settings", comment: "Settings"), systemImage: "gear")
                .padding(10)
        }
        .hoverEffect()
        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
        .background((Color.gray).opacity(0.3))
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

