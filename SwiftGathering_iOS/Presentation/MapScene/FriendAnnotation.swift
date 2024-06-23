//
//  FriendAnnotation.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 6/24/24.
//

import MapKit

class FriendAnnotation: NSObject, MKAnnotation {
    var friendId: Int
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(friendId: Int, coordinate: CLLocationCoordinate2D) {
        self.friendId = friendId
        self.coordinate = coordinate
        self.title = "Friend \(friendId)"
        super.init()
    }
}
