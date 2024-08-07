//
//  MapRepositoryImpl.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 6/14/24.
//

import RxSwift
import CoreLocation

class MapRepositoryImpl: MapRepository {
    private var locationHandler: LocationHandler
    private var stompHandler: STOMPHandler
    private let memberIdHolder: MemberIDHolder
    private let httpHandler: HTTPHandler
    private let tokenHolder: TokenHolder
    
    private var sessionID: String?
    
    init(locationHandler: LocationHandler, stompHandler: STOMPHandler, memberIdHolder: MemberIDHolder, httpHandler: HTTPHandler, tokenHolder: TokenHolder) {
        self.locationHandler = locationHandler
        self.stompHandler = stompHandler
        self.memberIdHolder = memberIdHolder
        self.httpHandler = httpHandler
        self.tokenHolder = tokenHolder
    }
    
    func setup(with sessionID: String) {
        stompHandler.sessionID = sessionID
        self.sessionID = sessionID
        stompHandler.registerSocket()
        locationHandler.start()
    }
    
    func fetchMyLocation() -> Observable<CLLocation> {
        return locationHandler.location
    }
    
    func broadcastMyLocation(_ myLocation: MyLocation) {
        do {
            guard let sessionID = stompHandler.sessionID else { return }
            let memberId = memberIdHolder.memberId
            let locationInput = MyLocationInput(senderId: memberId, channelId: sessionID, latitude: myLocation.latitude, longitude: myLocation.longitude)
            try stompHandler.send(to: .location, using: locationInput)
            
        } catch {}
    }
    
    func fetchFriendLocation() -> Observable<FriendLocation> {
        stompHandler
            .resultSubject
            .share()
            .compactMap { [weak self] jsonObject in
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject),
                   let message = try? JSONDecoder().decode(FriendLocationOutput.self, from: jsonData),
                   self?.memberIdHolder.memberId != message.senderId {
                    return message
                }
                return nil
            }
            .map{ $0.toDomain() }
    }
    
    func createGathering(with guestIDs: [Int]) -> Observable<CreatedSessionIdOutput> {
        let input = CreateSessionInput(senderID: memberIdHolder.memberId, guestIDs: guestIDs)
        return httpHandler
            .setPath(.gathering)
            .setPort(8080)
            .setMethod(.post)
            .addHeader(key: "Authorization", value: "Bearer \(tokenHolder.token)")
            .setRequestBody(input)
            .rxSend(expecting: CreatedSessionIdOutput.self)
    }
    
    func broadcastMyDrawing(_ drawing: MapStroke) {
        do {
            guard let sessionID = stompHandler.sessionID else { return }
            let memberId = memberIdHolder.memberId
            let input = DrawingDTO(mapStroke: drawing, senderId: memberId, channelId: sessionID)
            try stompHandler.send(to: .drawing, using: input)

        } catch {}
    }
    
    func fetchFriendDrawing() -> Observable<MapStroke> {
        stompHandler
            .resultSubject
            .share()
            .compactMap { jsonObject in
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject),
                   let message = try? JSONDecoder().decode(DrawingDTO.self, from: jsonData) {
                    return message.toDomain()
                }
                return nil
            }
    }
}
