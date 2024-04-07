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
    
    override func setUpWithError() throws {
        rabbitMQHandler.initialize()
    }

    override func tearDownWithError() throws {
        rabbitMQHandler.disconnect()
    }
    
    func testDefaultExchange() throws {
        // arrange
        let mockDelegate = MockRabbitMQHandlerDelegate(testCase: self)
        rabbitMQHandler.delegate = mockDelegate
        try rabbitMQHandler.listen(expecting: DrawingSampleOutput.self)
        let input = DrawingSampleInput(name: "testing default changes")
        
        // act
        let expectation = mockDelegate.expectResponse()
        try rabbitMQHandler.send(request: input)
        
        // assert
        wait(for: [mockDelegate.expectation], timeout: 3.0)
        
        let result = try XCTUnwrap(mockDelegate.response) as! DrawingSampleOutput
        XCTAssertEqual(result.name, DrawingSampleOutput(name: "testing default changes").name)
    }
}

class MockRabbitMQHandlerDelegate: RabbitMQHandlerDelegate {
    var response: Codable?
    var expectation: XCTestExpectation?
    private let testCase: XCTestCase
    
    init(testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    func expectResponse() -> XCTestExpectation {
        let expectation = testCase.expectation(description: "Expect response to arrive")
        self.expectation = expectation
        return expectation
    }
    
    func onReceive(response: any Codable) {
        func onReceive(response: Codable) {
//            if expectation != nil {
                self.response = response
//            }
            expectation?.fulfill()
            expectation = nil
        }
    }
}
