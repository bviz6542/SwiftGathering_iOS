//
//  StringExtensions.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/25/24.
//

import UIKit
import CoreGraphics

extension String {
    func toCGColor() -> CGColor {
        let components = self.split(separator: ",").compactMap { CGFloat(Double($0) ?? 0) }
        guard components.count == 4 else { return UIColor.black.cgColor }
        return CGColor(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
}
