import Foundation

enum SATAPreset: String, CaseIterable, Identifiable, Hashable {
    case intelAHCI
    case amdAHCI
    case asmedia
    case disabled

    var id: String { rawValue }

    var name: String {
        switch self {
        case .intelAHCI: return "Intel AHCI"
        case .amdAHCI: return "AMD AHCI"
        case .asmedia: return "ASMedia SATA"
        case .disabled: return "Disabled"
        }
    }

    var description: String {
        name
    }

    var modelName: String {
        name
    }

    var deviceType: String {
        "SATA Controller"
    }
}


