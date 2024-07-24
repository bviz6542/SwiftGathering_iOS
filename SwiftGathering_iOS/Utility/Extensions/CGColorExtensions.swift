//
//  CGColorExtensions.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/25/24.
//

import CoreGraphics

extension CGColor {
    func toString() -> String {
        guard let components = self.components, components.count == 4 else { return "" }
        return components.map { "\($0)" }.joined(separator: ",")
    }
}
