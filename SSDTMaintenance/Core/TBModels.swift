import Foundation

enum TBPreset: String, CaseIterable, Identifiable, Hashable {
    case alpineRidge
    case titanRidge
    case mapleRidge
    case disabled

    var id: String { rawValue }

    var name: String {
        switch self {
        case .alpineRidge: return "Alpine Ridge (TB3)"
        case .titanRidge: return "Titan Ridge (TB3)"
        case .mapleRidge: return "Maple Ridge (TB4)"
        case .disabled: return "Disabled"
        }
    }

    var description: String {
        switch self {
        case .alpineRidge: return "Older Thunderbolt 3"
        case .titanRidge: return "Most common TB3 controller"
        case .mapleRidge: return "Thunderbolt 4 controller"
        case .disabled: return "No Thunderbolt"
        }
    }

    var modelName: String {
        name
    }
}

