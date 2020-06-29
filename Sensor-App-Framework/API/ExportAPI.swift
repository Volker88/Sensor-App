//
//  ExportAPI.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 29.06.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct / Class Definition
class ExportAPI {
    
    // MARK: - Methods
    ///
    /// Export File
    ///
    /// Generate file and open Share Sheet
    ///
    /// - Parameters:
    ///   - exportText: String
    ///   - filename: String
    ///   - fileExtension: String
    ///
    func shareButton(exportText: String, filename: String, fileExtension: String = ".csv") {
        let fileName = "\(filename)\(fileExtension)"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        let exportText: String = exportText
        
        do {
            try exportText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error.localizedDescription)
        }
        
        var filesToShare = [Any]()
        filesToShare.append(path!)
        
        let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}
