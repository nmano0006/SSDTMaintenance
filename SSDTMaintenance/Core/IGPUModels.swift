import Foundation

enum IGPUPreset: String, CaseIterable, Identifiable, Hashable {
    case skylake
    case coffeelake
    case cometlake
    case icelake
    case tigerlake
    case raptorlake

    var id: String { rawValue }

    var name: String {
        switch self {
        case .skylake: return "Intel Skylake"
        case .coffeelake: return "Intel Coffee Lake"
        case .cometlake: return "Intel Comet Lake"
        case .icelake: return "Intel Ice Lake"
        case .tigerlake: return "Intel Tiger Lake"
        case .raptorlake: return "Intel Raptor Lake"
        }
    }

    var description: String {
        switch self {
        case .skylake: return "6th Gen Intel iGPU (legacy macOS)"
        case .coffeelake: return "8th–9th Gen Intel iGPU (stable)"
        case .cometlake: return "10th Gen Intel iGPU (recommended)"
        case .icelake: return "10th Gen mobile iGPU"
        case .tigerlake: return "11th Gen Intel iGPU (experimental)"
        case .raptorlake: return "12th–14th Gen Intel iGPU (headless)"
        }
    }

    /// ✅ iASL-safe: 4 bytes little-endian for Buffer()
    var platformIDBytes: String {
        switch self {
        case .skylake:    return "0x00, 0x00, 0x12, 0x19" // 0x19120000
        case .coffeelake: return "0x07, 0x00, 0x9B, 0x3E" // 0x3E9B0007
        case .cometlake:  return "0x00, 0x00, 0xC8, 0x9B" // 0x9BC80000
        case .icelake:    return "0x00, 0x00, 0x52, 0x8A" // 0x8A520000
        case .tigerlake:  return "0x00, 0x00, 0x49, 0x9A" // 0x9A490000
        case .raptorlake: return "0x00, 0x00, 0x80, 0xA7" // 0xA7800000
        }
    }
}
