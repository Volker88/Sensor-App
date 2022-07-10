//
//  ExportAPI.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 29.06.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import SwiftUI

class ExportAPI {
    /// Export File
    ///
    /// Generate file and open Share Sheet
    /// - Parameters:
    ///   - exportText: String
    ///   - filename: String
    ///   - fileExtension: String
    /// - Returns: URL?
    func getFile(exportText: String, filename: String, fileExtension: String = ".csv") -> URL? {
        let fileName = "\(filename)\(fileExtension)"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)

        let exportText: String = exportText

        do {
            try exportText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            Log.shared.add(.exportFile, .default, "\(path!)")
            Log.shared.add(.exportFile, .default, "\(exportText)")
        } catch {
            Log.shared.add(.exportFile, .fault, "\(error)")
        }

        return path
    }
}
