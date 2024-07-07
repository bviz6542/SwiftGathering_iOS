//
//  StompClientLibExtension.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/7/24.
//

import StompClientLib

extension StompClientLib {
    public func sendJSONForCodable(input: Codable, toDestination destination: String) {
        do {
            let jsonData = try JSONEncoder().encode(input)
            let theJSONText = String(data: jsonData, encoding: String.Encoding.utf8)!
            let header = ["content-type":"application/json;charset=UTF-8"]
            sendMessage(
                message: theJSONText,
                toDestination: destination,
                withHeaders: header,
                withReceipt: nil
            )
            
        } catch {
            print("error encoding JSON: \(error)")
        }
    }
}
