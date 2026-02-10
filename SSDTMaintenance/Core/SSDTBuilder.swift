//
//  SSDTBuilder.swift
//  SSDTMaintenance
//
//  FULL & FINAL – ALL SSDTs, View-Compatible
//

import Foundation

private func logicalCPUCount() -> Int {
    var count: UInt32 = 0
    var size = MemoryLayout<UInt32>.size

    sysctlbyname("hw.logicalcpu", &count, &size, nil, 0)
    return max(Int(count), 1)
}


struct SSDTBuilder {

    // MARK: - CPU PLUG (AUTO)

    static func cpuPlug() -> String {
        let cpuCount = logicalCPUCount()

        var dsl = """
        DefinitionBlock ("", "SSDT", 2, "SYSM", "CpuPlug", 0x00003000)
        {
            Scope (\\_SB)
            {
        """

        for index in 0..<cpuCount {
            let cpu = String(format: "CP%02X", index)
            let uid = String(format: "0x%02X", index)

            if index == 0 {
                dsl += """
                    Processor (\(cpu), \(uid), 0x00000510, 0x06)
                    {
                        Name (_HID, "ACPI0007")
                        Name (_UID, \(uid))
                        Method (_STA, 0) { Return (0x0F) }
                        Method (_DSM, 4)
                        {
                            If (Arg2 == Zero) { Return (Buffer (One) { 0x03 }) }
                            Return (Package (2) { "plugin-type", One })
                        }
                    }
                """
            } else {
                dsl += """
                    Processor (\(cpu), \(uid), 0x00000510, 0x06)
                    {
                        Name (_HID, "ACPI0007")
                        Name (_UID, \(uid))
                        Method (_STA, 0) { Return (0x0F) }
                    }
                """
            }
        }

        dsl += """
            }
        }
        """
        return dsl
    }




    // =====================================================
    // SSDT-DTPG
    // =====================================================
    static func dtpg() -> String {
        """
        DefinitionBlock ("", "SSDT", 2, "SYSM", "DTPG", 0x00001000)
        {
            Method (DTGP, 5, NotSerialized)
            {
                If ((Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b")))
                {
                    If ((Arg1 == One))
                    {
                        If ((Arg2 == Zero))
                        {
                            Arg4 = Buffer (One) { 0x03 }
                            Return (One)
                        }

                        If ((Arg2 == One))
                        {
                            Return (One)
                        }
                    }
                }

                Arg4 = Buffer (One) { 0x00 }
                Return (Zero)
            }
        }
        """
    }

    // =====================================================
    // SSDT-EC-USBX
    // =====================================================
    static func ecUSBX() -> String {
        """
        DefinitionBlock ("", "SSDT", 2, "SYSM", "ECUSBX", 0x00001000)
        {
            Device (EC)
            {
                Name (_HID, "ACID0001")
                Name (_UID, One)
            }

            Device (USBX)
            {
                Name (_ADR, Zero)

                Method (_DSM, 4, NotSerialized)
                {
                    If (!Arg2)
                    {
                        Return (Buffer (One) { 0x03 })
                    }

                    Return (Package ()
                    {
                        "kUSBSleepPowerSupply", 0x13EC,
                        "kUSBSleepPortCurrentLimit", 0x0834,
                        "kUSBWakePowerSupply", 0x13EC,
                        "kUSBWakePortCurrentLimit", 0x0834
                    })
                }
            }
        }
        """
    }

    // =====================================================
    // SSDT-HDEF (dynamic)
    // =====================================================
    static func hdef(
        path: String,
        layoutID: Int,
        alcLayoutID: Int,
        codecName: String
    ) -> String {
        """
        DefinitionBlock ("", "SSDT", 1, "SYSM", "HDEF", 0x00003000)
        {
            External (_SB_, DeviceObj)
            External (_SB_.PC00, DeviceObj)
            External (_SB_.PC00.HDAS, DeviceObj)
            External (DTGP, MethodObj)

            Scope (\\_SB.PC00)
            {
                Device (HDEF)
                {
                    Name (_ADR, 0x001F0003)

                    Method (_DSM, 4, NotSerialized)
                    {
                        If (!Arg2)
                        {
                            Return (Buffer (One) { 0x03 })
                        }

                        Local0 = Package ()
                        {
                            "layout-id", Buffer (4) { \(layoutID), 0, 0, 0 },
                            "alc-layout-id", Buffer (4) { \(alcLayoutID), 0, 0, 0 },
                            "AAPL,slot-name", Buffer () { "Built In" },
                            "hda-gfx", Buffer () { "onboard-1" },
                            "built-in", Buffer (One) { 0x01 },
                            "device_type", Buffer () { "High Definition Audio" },
                            "name", Buffer () { "\(codecName)" },
                            "PinConfigurations", Buffer (Zero) {}
                        }

                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }
            }

            Method (\\_SB.PC00.HDAS._STA, 0, NotSerialized)
            {
                Return (Zero)
            }
        }
        """
    }

    // =====================================================
    // SSDT-IGPU (Raptor Lake)
    // =====================================================
    static func igpuWithPreset(
        path: String,
        preset: IGPUPreset
    ) -> String {

        let name = String(describing: preset).lowercased()

        let platformID: [UInt8]
        let model: String

        if name.contains("raptor") {
            platformID = [0x07, 0x00, 0x9B, 0x3E]
            model = "Intel Raptor Lake-S UHD Graphics 770"

        } else if name.contains("alder") {
            platformID = [0x00, 0x00, 0x9A, 0x3E]
            model = "Intel Alder Lake-S UHD Graphics 770"

        } else if name.contains("head") {
            platformID = [0x00, 0x00, 0x00, 0x00]
            model = "Intel IGPU (Headless)"

        } else {
            platformID = [0x07, 0x00, 0x9B, 0x3E]
            model = "Intel Integrated Graphics"
        }

        return """
        DefinitionBlock ("", "SSDT", 2, "SYSM", "IGPU", 0x00000000)
        {
            External (_SB_.PC00, DeviceObj)
            External (_SB_.PC00.GFX0, DeviceObj)

            Scope (\\_SB.PC00)
            {
                Device (IGPU)
                {
                    Name (_ADR, 0x00020000)

                    Method (_DSM, 4, NotSerialized)
                    {
                        If (!Arg2) { Return (Buffer (One) { 0x03 }) }

                        Return (Package ()
                        {
                            "AAPL,slot-name", Buffer () { "Built In" },
                            "AAPL,ig-platform-id",
                            Buffer (4) { \(platformID.map { "0x" + String(format: "%02X", $0) }.joined(separator: ", ")) },
                            "built-in", Buffer (4) { 1,0,0,0 },
                            "model", Buffer () { "\(model)" },
                            "hda-gfx", Buffer () { "onboard-1" }
                        })
                    }
                }
            }

            Scope (\\_SB.PC00.GFX0)
            {
                Method (_STA, 0, NotSerialized) { Return (Zero) }
            }
        }
        """
    }



    // =====================================================
    // SSDT-GPU + HDAU
    // =====================================================
    static func gpuWithHDAU(
        gpuPath: String,
        hdauPath: String,
        preset: GPUPreset,
        slotName: String
    ) -> String {

        let name = String(describing: preset).lowercased()

        let agdp = name.contains("amd") ? "pikera" : ""
        let model =
            name.contains("rdna") ? "AMD Radeon RX 6000 Series" :
            name.contains("vega") ? "AMD Radeon RX Vega" :
            "Discrete GPU"

        return """
        DefinitionBlock ("", "SSDT", 2, "SYSM", "GPU", 0x00001000)
        {
            External (\(gpuPath), DeviceObj)
            External (\(hdauPath), DeviceObj)
            External (DTGP, MethodObj)

            Scope (\\\(gpuPath))
            {
                Device (GFX0)
                {
                    Name (_ADR, Zero)

                    Method (_DSM, 4, NotSerialized)
                    {
                        If (!Arg2) { Return (Buffer (One) { 0x03 }) }

                        Return (Package ()
                        {
                            "AAPL,slot-name", Buffer () { "\(slotName)" },
                            "agdpmod", Buffer () { "\(agdp)" },
                            "model", Buffer () { "\(model)" },
                            "hda-gfx", Buffer () { "onboard" }
                        })
                    }
                }

                Device (HDAU)
                {
                    Name (_ADR, One)

                    Method (_DSM, 4, NotSerialized)
                    {
                        If (!Arg2) { Return (Buffer (One) { 0x03 }) }
                        Return (Package () { "hda-gfx", Buffer () { "onboard-1" } })
                    }
                }
            }
        }
        """
    }



    // =====================================================
    // SSDT-LAN
    // =====================================================
    static func lanWithPreset(
        path: String,
        preset: LANPreset,
        slotName: String
    ) -> String {

        let name = String(describing: preset).lowercased()

        let model =
            name.contains("aquantia") ? "Aquantia AQC107 10GbE" :
            name.contains("realtek")  ? "Realtek RTL8125 2.5GbE" :
            name.contains("i225")     ? "Intel I225/I226 Ethernet" :
            "Intel Ethernet"

        return """
        DefinitionBlock ("", "SSDT", 2, "SYSM", "LAN", 0x00001000)
        {
            External (\(path), DeviceObj)
            External (DTGP, MethodObj)

            Scope (\\\(path))
            {
                Method (_DSM, 4, NotSerialized)
                {
                    If (!Arg2) { Return (Buffer (One) { 0x03 }) }

                    Local0 = Package ()
                    {
                        "AAPL,slot-name", Buffer () { "\(slotName)" },
                        "device_type", Buffer () { "Ethernet controller" },
                        "model", Buffer () { "\(model)" },
                        "built-in", Buffer (One) { 0x01 }
                    }

                    DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                    Return (Local0)
                }
            }
        }
        """
    }



    // =====================================================
    // SSDT-WIFI
    // =====================================================
    static func wifiWithPreset(
        path: String,
        preset: WIFIPreset,
        slotName: String
    ) -> String {

        let name = String(describing: preset).lowercased()
        let model = name.contains("broadcom")
            ? "Broadcom Wi-Fi (native macOS)"
            : "Intel Wi-Fi (itlwm)"

        return """
        DefinitionBlock ("", "SSDT", 2, "ACDT", "WIFI", 0x00000000)
        {
            External (\(path), DeviceObj)
            External (DTGP, MethodObj)

            Scope (\\\(path))
            {
                Device (WIFI)
                {
                    Name (_ADR, Zero)

                    Method (_DSM, 4, NotSerialized)
                    {
                        If (!Arg2) { Return (Buffer (One) { 0x03 }) }

                        Local0 = Package ()
                        {
                            "AAPL,slot-name", Buffer () { "\(slotName)" },
                            "device_type", Buffer () { "Network controller" },
                            "model", Buffer () { "\(model)" }
                        }

                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }
            }
        }
        """
    }



    // =====================================================
    // SSDT-TB3 (Titan Ridge RP09 – simplified but valid)
    // =====================================================
    static func tb3WithPreset(
        path: String,
        preset: TBPreset,
        slotName: String
    ) -> String {

        let name = String(describing: preset).lowercased()
        let model = name.contains("maple")
            ? "Intel Maple Ridge Thunderbolt 4"
            : "Intel Titan Ridge Thunderbolt 3"

        return """
        DefinitionBlock ("", "SSDT", 2, "MANO", "TB", 0x00000000)
        {
            External (\(path), DeviceObj)
            External (DTGP, MethodObj)

            Scope (\\\(path))
            {
                Device (UPSB)
                {
                    Name (_ADR, Zero)

                    Method (_DSM, 4, NotSerialized)
                    {
                        Local0 = Package ()
                        {
                            "AAPL,slot-name", Buffer () { "\(slotName)" },
                            "model", Buffer () { "\(model)" },
                            "PCI-Thunderbolt", One
                        }

                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }
            }
        }
        """
    }



    // =====================================================
    // SSDT-XHCI (15 ports)
    // =====================================================
    static func xhciWithPreset(
        path: String,
        preset: USBPreset
    ) -> String {

        let name = String(describing: preset).lowercased()

        // Decide port count / layout
        let ports: [(String, Int)] = {
            if name.contains("20") {
                return (1...10).map { ("HS\(String(format: "%02d", $0))", $0) } +
                       (1...10).map { ("SS\(String(format: "%02d", $0))", $0 + 10) }

            } else if name.contains("25") {
                return (1...13).map { ("HS\(String(format: "%02d", $0))", $0) } +
                       (1...12).map { ("SS\(String(format: "%02d", $0))", $0 + 13) }

            } else if name.contains("30") || name.contains("debug") {
                return (1...15).map { ("HS\(String(format: "%02d", $0))", $0) } +
                       (1...15).map { ("SS\(String(format: "%02d", $0))", $0 + 15) }

            } else if name.contains("type") {
                // Type-C focused (USB-C + TB)
                return [
                    ("HS01", 1), ("HS02", 2),
                    ("SS01", 3), ("SS02", 4),
                    ("SS03", 5), ("SS04", 6),
                    ("SS05", 7), ("SS06", 8)
                ]

            } else {
                // Default → 15-port recommended
                return (1...7).map { ("HS\(String(format: "%02d", $0))", $0) } +
                       (1...7).map { ("SS\(String(format: "%02d", $0))", $0 + 7) } +
                       [("USR1", 0x11)]
            }
        }()

        // Build Device blocks
        let portDevices = ports.map { port, adr in
            """
            Device (\(port))
            {
                Name (_ADR, \(adr))
                Name (_UPC, Package (4) { One, 0x03, Zero, Zero })
            }
            """
        }.joined(separator: "\n")

        return """
        DefinitionBlock ("", "SSDT", 2, "SYSM", "XHC", 0x00001000)
        {
            External (\(path), DeviceObj)
            External (\(path).RHUB, DeviceObj)

            Scope (\\\(path))
            {
                Scope (RHUB)
                {
                    Method (_STA, 0, NotSerialized)
                    {
                        If (_OSI ("Darwin")) { Return (Zero) }
                        Return (0x0F)
                    }
                }

                Device (XHUB)
                {
                    Name (_ADR, Zero)

                    Method (_STA, 0, NotSerialized)
                    {
                        If (_OSI ("Darwin")) { Return (0x0F) }
                        Return (Zero)
                    }

                    \(portDevices)
                }
            }
        }
        """
    }


    // =====================================================
    // SSDT-SAT0 / NVME (placeholders but valid)
    // =====================================================
    static func sataWithPreset(
        path: String,
        preset: SATAPreset
    ) -> String {

        // Read preset safely (no enum-case assumptions)
        let presetName = String(describing: preset).lowercased()

        let model =
            presetName.contains("intel")
            ? "Intel AHCI Controller"
            : "Generic SATA Controller"

        let compatible =
            presetName.contains("intel")
            ? "pci8086,a182"
            : "pci0000,0000"

        return """
        DefinitionBlock ("", "SSDT", 2, "SYSM", "SATA", 0x00001000)
        {
            External (_SB_.PC00, DeviceObj)
            External (\(path), DeviceObj)
            External (DTGP, MethodObj)

            Scope (\\_SB.PC00)
            {
                Device (SAT0)
                {
                    Name (_ADR, Zero)

                    Method (_DSM, 4, NotSerialized)
                    {
                        If (!Arg2)
                        {
                            Return (Buffer (One) { 0x03 })
                        }

                        Local0 = Package ()
                        {
                            "AAPL,slot-name",
                            Buffer () { "Built In" },

                            "built-in",
                            Buffer (One) { 0x00 },

                            "name",
                            Buffer () { "\(model)" },

                            "device_type",
                            Buffer () { "AHCI SATA Controller" },

                            "compatible",
                            Buffer () { "\(compatible)" }
                        }

                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }
            }
        }
        """
    }


    // =====================================================
    // SSDT-NVME-SSD0 (FULL, MODEL-AWARE)
    // =====================================================
    static func nvmeWithPreset(
        path: String,        // expected: _SB.PC00.PEG0
        preset: NVMePreset
    ) -> String {

        // Read preset safely (no enum case assumptions)
        let presetName = String(describing: preset).lowercased()

        // Defaults (Samsung-safe, also works generically)
        let deviceID: [UInt8] = [0x06, 0xA8, 0x00, 0x00]
        let vendorID: [UInt8] = [0x4D, 0x14, 0x00, 0x00]

        let shortName: String
        let model: String

        if presetName.contains("970") {
            shortName = "SSD-970"
            model = "SAMSUNG SSD-970-EVO-500GB"
        } else if presetName.contains("980") {
            shortName = "SSD-980"
            model = "SAMSUNG SSD-980-PRO"
        } else {
            shortName = "NVME"
            model = "NVMe Solid State Drive"
        }

        return """
        DefinitionBlock ("", "SSDT", 1, "SYSM", "SSD0", 0x00003000)
        {
            External (_SB_.PC00, DeviceObj)
            External (\(path), DeviceObj)
            External (\(path).PEGP, DeviceObj)
            External (DTGP, MethodObj)

            Device (\\\(path).SSD0)
            {
                Name (_ADR, Zero)

                Method (_DSM, 4, NotSerialized)
                {
                    If ((Arg2 == Zero))
                    {
                        Return (Buffer (One)
                        {
                            0x03
                        })
                    }

                    Local0 = Package ()
                    {
                        "AAPL,slot-name",
                        Buffer () { "Built In" },

                        "built-in",
                        Buffer () { "0x00" },

                        "device-id",
                        Buffer (4)
                        {
                            \(deviceID.map { "0x" + String(format: "%02X", $0) }.joined(separator: ", "))
                        },

                        "vendor-id",
                        Buffer (4)
                        {
                            \(vendorID.map { "0x" + String(format: "%02X", $0) }.joined(separator: ", "))
                        },

                        "reg-ltrovr",
                        Buffer (8)
                        {
                            0x00, 0x04, 0x00, 0x00,
                            0x00, 0x00, 0x00, 0x00
                        },

                        "name",
                        Buffer () { "\(shortName)" },

                        "model",
                        Buffer () { "\(model)" }
                    }

                    DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                    Return (Local0)
                }
            }

            Method (\\\(path).PEGP._STA, 0, NotSerialized)
            {
                Return (Zero)
            }
        }
        """
    }



}
