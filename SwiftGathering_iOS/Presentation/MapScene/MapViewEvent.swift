//
//  MapViewEvent.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/28/24.
//

import MapKit

enum MapViewEvent {
    case onReceivedSessionRequest(ReceivedSessionRequestOutput)
    case onFetchMyLocation(CLLocation)
    case onFetchFriendLocation(FriendLocation)
    case onStartGathering
    case onEndGathering
    case onReceiveFriendDrawing(MapStroke)
}
