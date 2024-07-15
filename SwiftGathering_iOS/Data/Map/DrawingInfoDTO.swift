//
//  DrawingInfoDTO.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/3/24.
//

import Foundation

struct DrawingInfoDTO: Codable {
    var latitude: Double
    var longitude: Double
    var color: String
    var width: CGFloat
    var mode: String
    var isEnd: Bool
}
