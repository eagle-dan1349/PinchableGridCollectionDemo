//
//  GridLayoutTests.swift
//  GridLayoutTests
//
//  Created by Daniil Orlov on 20.07.2022.
//

import XCTest
@testable import PinchableGridLayoutDemo

class GridLayoutTests: XCTestCase {

    func testInitialization() throws {
        let gridLayout = GridLayout()
        XCTAssertNotNil(gridLayout)
    }

    func testColumnCountError() throws {
        let gridLayout = GridLayout()
        
        XCTAssertThrowsError(try {
            try gridLayout.set(columnSizes: [])
        }())
    }

    func testRowCountError() throws {
        let gridLayout = GridLayout()
        XCTAssertThrowsError(try {
            try gridLayout.set(rowSizes: [])
        }())
    }
    
    func testCombinedColumnCountError() throws {
        let gridLayout = GridLayout()
        
        XCTAssertThrowsError(try {
            try gridLayout.set(columnSizes: [], rowSizes: [1, 2, 3])
        }())
    }

    func testCombinedRowCountError() throws {
        let gridLayout = GridLayout()
        XCTAssertThrowsError(try {
            try gridLayout.set(columnSizes: [1, 2, 3], rowSizes: [])
        }())
    }

    func testContentSize() {
        let gridLayout = GridLayout()
        let testFrame = CGRect(x: 20, y: 15, width: 200, height: 500)
        let collectionView = UICollectionView(frame: testFrame, collectionViewLayout: gridLayout)
        gridLayout.prepare()
        collectionView.frame = testFrame

        XCTAssertEqual(gridLayout.collectionViewContentSize, testFrame.size)
    }
}
