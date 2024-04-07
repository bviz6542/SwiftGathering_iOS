//
//  MockRabbitMQHandlerDelegate.swift
//  SwiftGathering_iOSTests
//
//  Created by 정준우 on 4/7/24.
//

import XCTest
@testable import SwiftGathering_iOS

class MockRabbitMQHandlerDelegate: RabbitMQHandlerDelegate {
    var response: Codable?
    var expectation: XCTestExpectation?
    private let testCase: XCTestCase
    
    init(testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    func expectResponse() {
        let expectation = testCase.expectation(description: "Expect response to arrive")
        self.expectation = expectation
    }
    
    func onReceive(response: any Codable) {
        func onReceive(response: Codable) {
            self.response = response
            expectation?.fulfill()
            expectation = nil
        }
    }
}
