//
//  SSDTGeneratorView.swift
//  SSDTMaintenance
//
//  FINAL – Generate button always visible (bottom bar)
//

import SwiftUI

struct SSDTGeneratorView: View {

    // MARK: - Bindings
    @Binding var outputFolder: URL?
    @Binding var statusMessage: String

    // MARK: - ACPI Paths
    @State private var hdefPath = "_SB.PC00.HDEF"
    @State private var igpuPath = "_SB.PC00.IGPU"
    @State private var gpuPath  = "_SB.PC00.PEG0.PEGP"
    @State private var hdauPath = "_SB.PC00.PEG0.PEGP.HDAU"
    @State private var lanPath  = "_SB.PC00.RP01.PXSX"
    @State private var wifiPath = "_SB.PC00.RP02.PXSX"
    @State private var sataPath = "_SB.PC00.SATA"
    @State private var nvmePath = "_SB.PC00.RP04.PXSX"
    @State private var tbPath   = "_SB.PC00.RP05.PXSX"
    @State private var xhciPath = "_SB.PC00.XHCI"

    // MARK: - Audio
    @State private var layoutID: Int = 7
    @State private var alcLayoutID: Int = 12
    @State private var codecName: String = "Realtek Audio"

    // MARK: - Presets
    @State private var igpuPreset: IGPUPreset = .raptorlake
    @State private var gpuPreset: GPUPreset = .rdna2
    @State private var lanPreset: LANPreset = .aquantiaAQC107
    @State private var wifiPreset: WIFIPreset = .intel
    @State private var tbPreset: TBPreset = .titanRidge
    @State private var usbPreset: USBPreset = .ports15
    @State private var sataPreset: SATAPreset = .intelAHCI
    @State private var nvmePreset: NVMePreset = .generic

    // MARK: - Output / Log
    @State private var compileLog: String = ""
    @State private var showLog: Bool = false

    var body: some View {
        VStack(spacing: 0) {

            // ✅ Main content scroll
            ScrollView {
                Form {
                    Section("ACPI Paths") {
                        pathField("HDEF", $hdefPath)
                        pathField("IGPU", $igpuPath)
                        pathField("GPU", $gpuPath)
                        pathField("HDAU", $hdauPath)
                        pathField("LAN", $lanPath)
                        pathField("Wi-Fi", $wifiPath)
                        pathField("SATA", $sataPath)
                        pathField("NVMe", $nvmePath)
                        pathField("Thunderbolt", $tbPath)
                        pathField("XHCI", $xhciPath)
                    }

                    Section("Audio") {
                        Stepper("Layout ID: \(layoutID)", value: $layoutID, in: 1...99)
                        Stepper("ALC Layout ID: \(alcLayoutID)", value: $alcLayoutID, in: 1...99)
                        TextField("Codec Name", text: $codecName)
                    }

                    Section("Graphics") {
                        modelPicker(
                            title: "Integrated GPU",
                            selection: $igpuPreset,
                            name: { $0.name },
                            description: { $0.description }
                        )
                        modelPicker(
                            title: "Discrete GPU",
                            selection: $gpuPreset,
                            name: { $0.name },
                            description: { $0.description }
                        )
                    }

                    Section("Connectivity") {
                        modelPicker(
                            title: "LAN",
                            selection: $lanPreset,
                            name: { $0.name },
                            description: { $0.description }
                        )
                        modelPicker(
                            title: "Wi-Fi",
                            selection: $wifiPreset,
                            name: { $0.name },
                            description: { $0.description }
                        )
                        modelPicker(
                            title: "Thunderbolt",
                            selection: $tbPreset,
                            name: { $0.name },
                            description: { $0.description }
                        )
                    }

                    Section("USB & Storage") {
                        modelPicker(
                            title: "USB",
                            selection: $usbPreset,
                            name: { $0.name },
                            description: { $0.description }
                        )
                        modelPicker(
                            title: "SATA",
                            selection: $sataPreset,
                            name: { $0.name },
                            description: { $0.description }
                        )
                        modelPicker(
                            title: "NVMe",
                            selection: $nvmePreset,
                            name: { $0.name },
                            description: { $0.description }
                        )
                    }

                    // Add bottom padding so form content doesn't sit under the button bar
                    Section {
                        EmptyView()
                    }
                    .frame(height: 20)
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)
            }

            // ✅ Log panel (optional)
            if showLog {
                Divider()
                ScrollView {
                    Text(compileLog.isEmpty ? "No log yet." : compileLog)
                        .font(.system(.body, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .frame(minHeight: 220, maxHeight: 260)
                .background(Color(NSColor.textBackgroundColor))
            }

            Divider()

            // ✅ Fixed bottom action bar (ALWAYS VISIBLE)
            HStack(spacing: 12) {
                Button {
                    generateAll()
                } label: {
                    Label("Generate ALL SSDTs", systemImage: "bolt.fill")
                        .frame(minWidth: 220)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button(showLog ? "Hide Log" : "Show Log") {
                    withAnimation { showLog.toggle() }
                }
                .buttonStyle(.bordered)

                Spacer()

                // Optional: show current folder short status
                if let folder = outputFolder {
                    Text(folder.lastPathComponent)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                } else {
                    Text("No folder selected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
        }
    }

    // MARK: - UI Helpers

    private func pathField(_ title: String, _ binding: Binding<String>) -> some View {
        TextField(title, text: binding)
            .font(.system(.body, design: .monospaced))
    }

    private func modelPicker<T>(
        title: String,
        selection: Binding<T>,
        name: @escaping (T) -> String,
        description: @escaping (T) -> String
    ) -> some View
    where T: CaseIterable & Identifiable & Hashable {

        VStack(alignment: .leading, spacing: 6) {
            Picker(title, selection: selection) {
                ForEach(Array(T.allCases), id: \.self) { item in
                    Text(name(item)).tag(item)
                }
            }

            Text(description(selection.wrappedValue))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Generation (REAL PIPELINE)

    private func generateAll() {
        guard let folder = outputFolder else {
            statusMessage = "❌ Please select an output folder"
            return
        }

        do {
            if !FileManager.default.fileExists(atPath: folder.path) {
                try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            }
        } catch {
            statusMessage = "❌ Cannot create output folder: \(error.localizedDescription)"
            return
        }

        statusMessage = "⚙️ Generating SSDTs…"
        compileLog = ""
        showLog = true

        let ssdtList: [(name: String, dsl: String)] = [
            ("SSDT-PLUG", SSDTBuilder.cpuPlug()),
            ("SSDT-DTPG", SSDTBuilder.dtpg()),
            ("SSDT-EC-USBX", SSDTBuilder.ecUSBX()),

            ("SSDT-HDEF", SSDTBuilder.hdef(
                path: hdefPath,
                layoutID: layoutID,
                alcLayoutID: alcLayoutID,
                codecName: codecName
            )),

            ("SSDT-IGPU", SSDTBuilder.igpuWithPreset(path: igpuPath, preset: igpuPreset)),

            ("SSDT-GPU", SSDTBuilder.gpuWithHDAU(
                gpuPath: gpuPath,
                hdauPath: hdauPath,
                preset: gpuPreset,
                slotName: "PCIe Slot 1"
            )),

            ("SSDT-LAN", SSDTBuilder.lanWithPreset(
                path: lanPath,
                preset: lanPreset,
                slotName: "PCIe Slot 4"
            )),

            ("SSDT-WIFI", SSDTBuilder.wifiWithPreset(
                path: wifiPath,
                preset: wifiPreset,
                slotName: "PCIe Slot 3"
            )),

            ("SSDT-TB3", SSDTBuilder.tb3WithPreset(
                path: tbPath,
                preset: tbPreset,
                slotName: "PCIe Slot 5"
            )),

            ("SSDT-XHCI", SSDTBuilder.xhciWithPreset(path: xhciPath, preset: usbPreset)),
            ("SSDT-SATA", SSDTBuilder.sataWithPreset(path: sataPath, preset: sataPreset)),
            ("SSDT-NVME", SSDTBuilder.nvmeWithPreset(path: nvmePath, preset: nvmePreset))
        ]

        var wroteAny = false

        do {
            for item in ssdtList {
                let trimmed = item.dsl.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty {
                    compileLog += "▶ \(item.name)\n(SKIPPED – empty SSDT)\n\n"
                    continue
                }

                wroteAny = true

                let dslURL = try SSDTFileManager.writeDSL(
                    name: item.name,
                    content: item.dsl,
                    to: folder
                )

                let result = SSDTCompiler.compile(dslURL: dslURL)

                compileLog += "▶ \(item.name)\n"
                compileLog += result.stdout
                if !result.stderr.isEmpty {
                    compileLog += "\n--- STDERR ---\n"
                    compileLog += result.stderr
                }
                compileLog += "\n\n"
            }

            statusMessage = wroteAny ? "✅ SSDTs generated successfully" : "⚠️ Nothing generated"

        } catch {
            statusMessage = "❌ Generation failed: \(error.localizedDescription)"
            compileLog += "❌ Fatal error: \(error.localizedDescription)\n"
        }
    }
}
