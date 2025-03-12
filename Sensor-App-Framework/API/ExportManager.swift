//
//  ExportManager.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 29.06.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import OSLog
import SwiftUI

public class ExportManager {

    public init() {}

    /// Export File
    ///
    /// Generate file and open Share Sheet
    /// - Parameters:
    ///   - exportText: String
    ///   - filename: String
    ///   - fileExtension: String
    /// - Returns: URL?
    public func getFile(exportText: String, filename: String, fileExtension: String = ".csv") -> URL {
        // swiftlint:disable force_unwrapping
        let fileName = "\(filename)\(fileExtension)"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)

        let exportText: String = exportText

        do {
            try exportText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            Logger.exportFile.debug("\(path!)")
            Logger.exportFile.debug("\(exportText)")
        } catch {
            Logger.exportFile.error("\(error)")
        }

        return path!
        // swiftlint:enable force_unwrapping
    }
}
