import Foundation

enum USBPreset: String, CaseIterable, Identifiable, Hashable {
    case ports15
    case ports20
    case ports25
    case ports30
    case typeCFocused
    case allEnabled

    var id: String { rawValue }

    var name: String {
        switch self {
        case .ports15: return "15 Ports (Recommended)"
        case .ports20: return "20 Ports"
        case .ports25: return "25 Ports"
        case .ports30: return "30 Ports"
        case .typeCFocused: return "Type-C Focused"
        case .allEnabled: return "All Ports (Debug)"
        }
    }

    var description: String {
        switch self {
        case .ports15: return "macOS compliant"
        case .ports20: return "Extended ports"
        case .ports25: return "Requires port limit patch"
        case .ports30: return "Testing only"
        case .typeCFocused: return "USB-C optimized"
        case .allEnabled: return "Not recommended"
        }
    }
}

