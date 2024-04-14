//
//  DrawingInfoDTO.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/3/24.
//

import Foundation

struct DrawingInfoDTO: Codable {
    let fullWidth: CGFloat
    let fullHeight: CGFloat
    let x: CGFloat
    let y: CGFloat
    let event: String
}
