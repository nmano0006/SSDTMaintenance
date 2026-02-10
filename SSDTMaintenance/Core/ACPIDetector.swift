//
//  ACPIDetector.swift
//  SSDTMaintenance
//
//  Lightweight ACPI helper (device paths only)
//
//  Author: SYSM Project
//

import Foundation

enum ACPIDetector {

    // MARK: - Normalize User ACPI Path

    static func normalize(path: String) -> String {
        path
            .replacingOccurrences(of: "_SB_.", with: "_SB.")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Validate ACPI Path Format

    static func isValidACPIPath(_ path: String) -> Bool {
        let p = normalize(path: path)
        return p.hasPrefix("_SB.")
    }

    // MARK: - CPU (PLUG MUST NOT USE THIS)

    static func cpuPath() -> String {
        // DO NOT use for SSDT-PLUG
        return "_PR.CPU0"
    }

    // MARK: - Common Defaults (Safe Suggestions)

    static let defaultPaths: [String: String] = [
        "HDEF": "_SB.PC00.HDEF",
        "IGPU": "_SB.PC00.IGPU",
        "GPU":  "_SB.PC00.PEG0.PEGP",
        "SATA": "_SB.PC00.SATA",
        "LAN":  "_SB.PC00.RP01.PXSX",
        "WIFI": "_SB.PC00.RP02.PXSX",
        "TB3":  "_SB.PC00.RP05.PXSX"
    ]
}
