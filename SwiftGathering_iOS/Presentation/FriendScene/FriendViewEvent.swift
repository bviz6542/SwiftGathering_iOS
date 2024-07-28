//
//  FriendViewEvent.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/28/24.
//

enum FriendViewEvent {
    case onUpdateFriendInfos
    case onFetchFailFriendInfos(Error)
    case onCreateFailGathering(Error)
    case onToggleViewMode(FriendViewMode)
    case onStartLoading
    case onEndLoading
}
