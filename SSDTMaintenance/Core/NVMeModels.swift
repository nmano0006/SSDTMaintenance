import Foundation

enum NVMePreset: String, CaseIterable, Identifiable, Hashable {
    case generic
    case samsung
    case westernDigital
    case hynix
    case disabled

    var id: String { rawValue }

    var name: String {
        switch self {
        case .generic: return "Generic NVMe"
        case .samsung: return "Samsung NVMe"
        case .westernDigital: return "Western Digital NVMe"
        case .hynix: return "SK Hynix NVMe"
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
        "NVMe Controller"
    }

    var builtIn: Bool {
        self != .disabled
    }
}


