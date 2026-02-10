import Foundation

enum GPUPreset: String, CaseIterable, Identifiable, Hashable {
    case rdna2
    case rdna3
    case navi10
    case polaris
    case nvidiaDisabled

    var id: String { rawValue }

    var name: String {
        switch self {
        case .rdna2: return "AMD RDNA2"
        case .rdna3: return "AMD RDNA3"
        case .navi10: return "AMD Navi 10"
        case .polaris: return "AMD Polaris"
        case .nvidiaDisabled: return "NVIDIA Disabled"
        }
    }

    var description: String {
        switch self {
        case .rdna2: return "RX 6000 series (native macOS)"
        case .rdna3: return "RX 7000 series (experimental)"
        case .navi10: return "RX 5000 series"
        case .polaris: return "RX 400/500 series"
        case .nvidiaDisabled: return "Disable NVIDIA dGPU"
        }
    }

    var modelName: String {
        switch self {
        case .rdna2: return "AMD Radeon RX 6000"
        case .rdna3: return "AMD Radeon RX 7000"
        case .navi10: return "AMD Radeon RX 5000"
        case .polaris: return "AMD Radeon RX 500"
        case .nvidiaDisabled: return "NVIDIA GPU"
        }
    }

    var portNames: [String] {
        switch self {
        case .rdna2, .rdna3:
            return ["DP-0", "DP-1", "DP-2", "HDMI-0"]
        case .navi10:
            return ["DP-0", "DP-1", "HDMI-0"]
        case .polaris:
            return ["DP-0", "HDMI-0"]
        case .nvidiaDisabled:
            return []
        }
    }
}
