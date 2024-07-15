//
//  DrawingInfoDTO.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/3/24.
//

import Foundation

struct DrawingInfoDTO: Codable {
    var points: [DrawingPointDTO]
    var color: String
    var width: CGFloat
    var mode: String
}
