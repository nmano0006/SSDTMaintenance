import Foundation

enum WIFIPreset: String, CaseIterable, Identifiable, Hashable {
    case intel
    case broadcom
    case broadcomLegacy
    case disabled

    var id: String { rawValue }

    var name: String {
        switch self {
        case .intel: return "Intel Wi-Fi"
        case .broadcom: return "Broadcom Wi-Fi"
        case .broadcomLegacy: return "Broadcom Legacy"
        case .disabled: return "Disabled"
        }
    }

    var description: String {
        switch self {
        case .intel: return "Requires itlwm / AirportItlwm"
        case .broadcom: return "Native macOS support"
        case .broadcomLegacy: return "Limited support"
        case .disabled: return "Ethernet only"
        }
    }

    var compatible: String {
        switch self {
        case .intel: return "pci8086"
        case .broadcom, .broadcomLegacy: return "pci14e4"
        case .disabled: return ""
        }
    }

    var modelName: String {
        name
    }
}

