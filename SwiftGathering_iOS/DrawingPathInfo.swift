//
//  DrawingPathInfo.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/3/24.
//

import UIKit

struct DrawingPathInfo {
    var path = UIBezierPath()
    var mode: DrawingMode = .pen
    var color: CGColor = UIColor.black.cgColor
    var width: CGFloat = .zero
}
