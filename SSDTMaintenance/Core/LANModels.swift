import Foundation

enum LANPreset: String, CaseIterable, Identifiable, Hashable {
    case intelI219
    case intelI225
    case realtekRTL8125
    case aquantiaAQC107

    var id: String { rawValue }

    var name: String {
        switch self {
        case .intelI219: return "Intel I219"
        case .intelI225: return "Intel I225 / I226"
        case .realtekRTL8125: return "Realtek RTL8125"
        case .aquantiaAQC107: return "Aquantia AQC107"
        }
    }

    var description: String { "\(name) Ethernet" }

    var modelName: String { "\(name) Ethernet" }

    var compatible: String {
        switch self {
        case .intelI219, .intelI225: return "pci8086"
        case .realtekRTL8125: return "pci10ec"
        case .aquantiaAQC107: return "pci1d6a"
        }
    }

    var builtIn: Bool { true }

    /// ✅ iASL-safe: 2 bytes little-endian for Buffer()
    var deviceIDBytes: String {
        switch self {
        case .intelI219:        return "0xB8, 0x15" // 0x15B8
        case .intelI225:        return "0xF3, 0x15" // 0x15F3
        case .realtekRTL8125:   return "0x25, 0x81" // 0x8125
        case .aquantiaAQC107:   return "0xB1, 0x07" // 0x07B1
        }
    }
}
