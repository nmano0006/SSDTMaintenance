//
//  SSDTCompiler.swift
//  SSDTMaintenance
//
//  Compile SSDT DSL → AML using iasl (GUI-safe, no .hex output)
//
//  Author: SYSM Project
//

import Foundation

struct SSDTCompileResult {
    let success: Bool
    let stdout: String
    let stderr: String
}

enum SSDTCompiler {

    // MARK: - Compile DSL → AML

    static func compile(dslURL: URL) -> SSDTCompileResult {

        guard let iaslPath = findIASL() else {
            return SSDTCompileResult(
                success: false,
                stdout: "",
                stderr: """
                iasl not found.

                Checked paths:
                - /usr/bin/iasl
                - /usr/local/bin/iasl
                - /opt/homebrew/bin/iasl
                """
            )
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: iaslPath)
        process.arguments = [
            "-ve",                 // verbose + errors
            "-tc",                 // compile table
            dslURL.lastPathComponent
        ]
        process.currentDirectoryURL = dslURL.deletingLastPathComponent()

        let outPipe = Pipe()
        let errPipe = Pipe()
        process.standardOutput = outPipe
        process.standardError  = errPipe

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return SSDTCompileResult(
                success: false,
                stdout: "",
                stderr: "Failed to run iasl: \(error.localizedDescription)"
            )
        }

        let stdout = String(
            data: outPipe.fileHandleForReading.readDataToEndOfFile(),
            encoding: .utf8
        ) ?? ""

        let stderr = String(
            data: errPipe.fileHandleForReading.readDataToEndOfFile(),
            encoding: .utf8
        ) ?? ""

        let success = process.terminationStatus == 0

        // Remove unwanted .hex file (iasl always generates it)
        if success {
            removeHexFile(for: dslURL)
        }

        return SSDTCompileResult(
            success: success,
            stdout: stdout,
            stderr: stderr
        )
    }

    // MARK: - Locate iasl (GUI-safe, no PATH dependency)

    private static func findIASL() -> String? {
        let paths = [
            "/usr/bin/iasl",            // system / bundled
            "/usr/local/bin/iasl",      // Intel Homebrew
            "/opt/homebrew/bin/iasl"    // Apple Silicon Homebrew
        ]

        for path in paths {
            if FileManager.default.isExecutableFile(atPath: path) {
                return path
            }
        }
        return nil
    }

    // MARK: - Remove .hex output

    private static func removeHexFile(for dslURL: URL) {
        let hexURL = dslURL
            .deletingPathExtension()
            .appendingPathExtension("hex")

        if FileManager.default.fileExists(atPath: hexURL.path) {
            try? FileManager.default.removeItem(at: hexURL)
        }
    }
}
