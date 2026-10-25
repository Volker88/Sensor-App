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
        let fileName = "\(Self.sanitizedFilename(filename))\(fileExtension)"
        let path = URL.temporaryDirectory.appending(path: fileName)

        let exportText: String = exportText

        do {
            try exportText.write(to: path, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            Logger.exportFile.error("\(error)")
        }

        return path
    }

    /// Sanitize Filename
    ///
    /// Replaces characters that are invalid or reserved in file names (path separators, `:` and the
    /// Windows-reserved set, since exports are often opened elsewhere) with `-`. User-facing names
    /// like "18 Oct 2026, 09:14" stay untouched in the UI; only the exported file name is sanitized.
    /// - Parameter filename: String
    /// - Returns: String, never empty
    public static func sanitizedFilename(_ filename: String) -> String {
        let invalidCharacters: Set<Character> = ["/", "\\", ":", "*", "?", "\"", "<", ">", "|"]
        let sanitized = String(filename.map { invalidCharacters.contains($0) || $0.isNewline ? "-" : $0 })
            .trimmingCharacters(in: .whitespaces)

        // A leading dot would create a hidden file
        let visible = String(sanitized.drop(while: { $0 == "." }))
        return visible.isEmpty ? "export" : visible
    }
}
