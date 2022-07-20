//
//  ViewControllerTests.swift
//  PinchableGridLayoutDemoTests
//
//  Created by Daniil Orlov on 20.07.2022.
//

import XCTest
@testable import PinchableGridLayoutDemo

class ViewControllerTests: XCTestCase {

    func testAddsPinchGestureRecognizer() {
        let vc = ViewController()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        vc.collectionView = collectionView

        vc.viewDidLoad()

        XCTAssertTrue((collectionView.gestureRecognizers ?? []).contains { $0 is UIPinchGestureRecognizer })
    }

    func testRefreshesData() {
        let vc = ViewController()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        vc.collectionView = collectionView

        vc.handleRefreshItemTap(UIBarButtonItem())

        XCTAssertEqual(vc.initialColumnSizes, [1, 1, 1])
        XCTAssertEqual(vc.initialRowSizes, [1, 1, 1])
        XCTAssertTrue(collectionView.collectionViewLayout is GridLayout)
    }

    func testHandlesPinchGesture() {
        let vc = ViewController()
        let gridLayout = GridLayout()

        let testFrame = CGRect(x: 0, y: 0, width: 100, height: 100)

        let collectionView = UICollectionView(frame: testFrame, collectionViewLayout: gridLayout)
        vc.collectionView = collectionView

        let pinchRecognizer = UIPinchGestureRecognizer()

        vc.recognizePinchGesture(from: pinchRecognizer)
    }
}
