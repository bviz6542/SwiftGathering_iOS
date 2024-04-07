//
//  RabbitMQHandlerTests.swift
//  SwiftGathering_iOSTests
//
//  Created by 정준우 on 4/7/24.
//

import XCTest
@testable import SwiftGathering_iOS

final class RabbitMQHandlerTests: XCTestCase {
    var rabbitMQHandler = RabbitMQHandler()
    var response: Codable?
    var expectation: XCTestExpectation?
    
    override func setUpWithError() throws {
        rabbitMQHandler.initialize()
    }

    override func tearDownWithError() throws {
        rabbitMQHandler.disconnect()
    }
    
    func testDefaultExchange() throws {
        // arrange
        rabbitMQHandler.delegate = self
        try rabbitMQHandler.listen(expecting: DrawingSampleOutput.self)
        let input = DrawingSampleInput(name: "testing default changes")
        
        // act
        expectation = self.expectation(description: "Expect response to arrive")
        try rabbitMQHandler.send(request: input)
        
        // assert
        waitForExpectations(timeout: 3.0)
        let result = try XCTUnwrap(response) as! DrawingSampleOutput
        XCTAssertEqual(result.name, "testing default changes")
    }
}

extension RabbitMQHandlerTests: RabbitMQHandlerDelegate {
    func onReceive(response: Codable) {
        self.response = response
        expectation?.fulfill()
        expectation = nil
    }
}
