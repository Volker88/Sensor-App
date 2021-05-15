//
//  SettingsViewModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 15.05.21.
//

// MARK: - Import
import SwiftUI

// MARK: - Class Definition
class SettingsViewModel: ObservableObject {

    // MARK: - Define Constants / Variables
    @Published var currentAppIconIndex = 0
    var iconNames: [String] = ["Default", "Alternative-1", "Alternative-2"]

    // MARK: - Initializer
    init() {
        if let currentIcon = UIApplication.shared.alternateIconName {
            self.currentAppIconIndex = iconNames.firstIndex(of: currentIcon) ?? 0
        }
    }

    // MARK: - Methods
    func changeIcon(value: Int) {
        let index = iconNames.firstIndex(of: UIApplication.shared.alternateIconName ?? "Default") ?? 0

        if value == 0 {
            UIApplication.shared.setAlternateIconName(nil)
        }

        if index != value {
            UIApplication.shared.setAlternateIconName(iconNames[value]) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Success!")
                }
            }
        }
    }
}
