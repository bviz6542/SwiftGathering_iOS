//
//  FriendInfoUIModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/7/24.
//

class FriendInfoUIModel {
    var friendInfo: FriendInfo
    var isSelected: Bool
    
    init(friendInfo: FriendInfo, isSelected: Bool) {
        self.friendInfo = friendInfo
        self.isSelected = isSelected
    }
}
