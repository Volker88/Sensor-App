//
//  SidebarButton.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 09.10.20.
//

import SwiftUI

struct SidebarButton: View {

    // MARK: - Define Constants / Variables
    let action: () -> Void

    // MARK: - Define Constants / Variables
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: "line.horizontal.3")
                .navigationBarItemModifier(accessibility: "Save")
        }
        .accessibility(identifier: "Save Button")
    }
}

// MARK: - Preview
struct SidebarButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            SidebarButton(action: { })
                    .colorScheme(scheme)
                    .previewLayout(.sizeThatFits)
            }
    }
}
