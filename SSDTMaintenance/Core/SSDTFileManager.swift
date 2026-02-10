//
//  SSDTFileManager.swift
//  SSDTMaintenance
//
//  Handles SSDT output folder and file writing
//
//  Author: SYSM Project
//

import Foundation

enum SSDTFileManager {

    // MARK: - Write DSL to Selected Folder

    static func writeDSL(
        name: String,
        content: String,
        to folder: URL
    ) throws -> URL {

        let url = folder.appendingPathComponent("\(name).dsl")
        try content.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    // MARK: - AML URL helper (optional)

    static func amlURL(for dslURL: URL) -> URL {
        dslURL.deletingPathExtension().appendingPathExtension("aml")
    }
}
