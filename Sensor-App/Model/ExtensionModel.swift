//
//  ExtensionModel.swift
//  Sensor App
//
//  Created by Volker Schmitt on 01.06.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Localization Extension
extension String {
    var localized : String {return NSLocalizedString(self, comment: "")}
}


// MARK: - UILabel
extension UILabel {
    // User defined Extension Method
    func customizedLabel(labelType : String) {
        if labelType == "Header" { // Header Label
            
            let borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0) // Border Color
            self.backgroundColor = UIColor(red: 64 / 255, green: 64 / 255, blue: 64 / 255, alpha: 1.0)
            self.layer.borderWidth = 1.0 // Border width
            self.layer.cornerRadius = 15.0 // Corder Radius
            self.layer.borderColor = borderColor.cgColor // Border Color
            self.textColor = UIColor.white // Text Color
            self.layer.masksToBounds = true // Mask the bound
            self.clipsToBounds = true // Clip to Bounds
        } else if labelType == "Standard" { // Standard Label
            let borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0) // Border Color
            self.backgroundColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1.0)
            self.layer.borderWidth = 1.0 // Border width
            self.layer.cornerRadius = 10.0 // Corder Radius
            self.layer.borderColor = borderColor.cgColor // Border Color
            self.textColor = UIColor.white // Text Color
            self.layer.masksToBounds = true // Mask the bound
            self.clipsToBounds = true // Clip to Bounds
        }
    }
}


// MARK: - UIButton
extension UIButton {
    // User defined Extension Method
    func customizedButton() {
        let borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0) // Border Color
        self.backgroundColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1.0)
        self.layer.borderWidth = 1.0 // Border width
        self.layer.cornerRadius = 15.0 // Corder Radius
        self.layer.borderColor = borderColor.cgColor // Border Color
        self.setTitleColor(.white, for: .normal) // Text Color
        self.layer.masksToBounds = true // Mask the bound
        self.clipsToBounds = true // Clip to Bounds
    }
}


// MARK: - UIView
extension UIView {
    func customizedUIView() {
        self.backgroundColor = UIColor(red: 191 / 255, green: 191 / 255, blue: 191 / 255, alpha: 1)
    }
}


// MARK: - UITableView
extension UITableView {
    func customizedTableView() {
        let borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0) // Border Color
        self.backgroundColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1.0)
        self.layer.borderWidth = 1.0 // Border width
        self.layer.cornerRadius = 10.0 // Corder Radius
        self.layer.borderColor = borderColor.cgColor // Border Color
        self.layer.masksToBounds = true // Mask the bound
        self.clipsToBounds = true // Clip to Bounds
    }
}


// MARK: - UIToolbar
extension UIToolbar {
    func customizedToolBar() {
        self.backgroundColor = UIColor(red: 64 / 255, green: 64 / 255, blue: 64 / 255, alpha: 1.0)
    }
}
