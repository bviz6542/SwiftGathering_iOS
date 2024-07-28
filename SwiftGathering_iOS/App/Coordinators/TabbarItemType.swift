//
//  TabBarItemType.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/4/24.
//

enum TabBarItemType: String, CaseIterable {
    case map
    case friend
    case bookmark
    case profile
    
    init?(index: Int) {
        switch index {
        case 0: self = .map
        case 1: self = .friend
        case 2: self = .bookmark
        case 3: self = .profile
        default: return nil
        }
    }
    
    func toInt() -> Int {
        switch self {
        case .map: return 0
        case .friend: return 1
        case .bookmark: return 2
        case .profile: return 3
        }
    }
    
    func toName() -> String {
        switch self {
        case .map: return "Map"
        case .friend: return "Friend"
        case .bookmark: return "Bookmark"
        case .profile: return "Profile"
        }
    }
    
    func toIconName() -> String {
        switch self {
        case .map: return "map.fill"
        case .friend: return "person.3.fill"
        case .bookmark: return "bookmark.fill"
        case .profile: return "person.circle"
        }
    }
}
