//
//  UtilityTests.swift
//  PinchableGridLayoutDemoTests
//
//  Created by Daniil Orlov on 20.07.2022.
//

import XCTest
@testable import PinchableGridLayoutDemo

class UtilityTests: XCTestCase {

    func testMinimum() {
        let min = 10
        let max = 15
        let value = 5
        
        XCTAssertEqual(clamp(value, min, max), min)
    }

    func testMaximumm() {
        let min = 10
        let max = 15
        let value = 25
        
        XCTAssertEqual(clamp(value, min, max), max)
    }

    func testFitting() {
        let min = 10
        let max = 15
        let value = 12
        
        XCTAssertEqual(clamp(value, min, max), value)
    }
}
