//
//  CGBlendModeExtensions.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/21/24.
//

import CoreGraphics

extension CGBlendMode {
    init(_ string: String) {
        switch string {
        case "normal": self = .normal
        case "multiply": self = .multiply
        case "screen": self = .screen
        case "overlay": self = .overlay
        case "darken": self = .darken
        case "lighten": self = .lighten
        case "colorDodge": self = .colorDodge
        case "colorBurn": self = .colorBurn
        case "softLight": self = .softLight
        case "hardLight": self = .hardLight
        case "difference": self = .difference
        case "exclusion": self = .exclusion
        case "hue": self = .hue
        case "saturation": self = .saturation
        case "color": self = .color
        case "luminosity": self = .luminosity
        case "clear": self = .clear
        case "copy": self = .copy
        case "sourceIn": self = .sourceIn
        case "sourceOut": self = .sourceOut
        case "sourceAtop": self = .sourceAtop
        case "destinationOver": self = .destinationOver
        case "destinationIn": self = .destinationIn
        case "destinationOut": self = .destinationOut
        case "destinationAtop": self = .destinationAtop
        case "xor": self = .xor
        case "plusDarker": self = .plusDarker
        case "plusLighter": self = .plusLighter
        default: self = .normal
        }
    }

    func toString() -> String {
        switch self {
        case .normal: return "normal"
        case .multiply: return "multiply"
        case .screen: return "screen"
        case .overlay: return "overlay"
        case .darken: return "darken"
        case .lighten: return "lighten"
        case .colorDodge: return "colorDodge"
        case .colorBurn: return "colorBurn"
        case .softLight: return "softLight"
        case .hardLight: return "hardLight"
        case .difference: return "difference"
        case .exclusion: return "exclusion"
        case .hue: return "hue"
        case .saturation: return "saturation"
        case .color: return "color"
        case .luminosity: return "luminosity"
        case .clear: return "clear"
        case .copy: return "copy"
        case .sourceIn: return "sourceIn"
        case .sourceOut: return "sourceOut"
        case .sourceAtop: return "sourceAtop"
        case .destinationOver: return "destinationOver"
        case .destinationIn: return "destinationIn"
        case .destinationOut: return "destinationOut"
        case .destinationAtop: return "destinationAtop"
        case .xor: return "xor"
        case .plusDarker: return "plusDarker"
        case .plusLighter: return "plusLighter"
        @unknown default: return "normal"
        }
    }
}

