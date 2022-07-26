//
//  GridViewControllerSpec.swift
//  PinchableGridLayoutDemoTests
//
//  Created by Daniil Orlov on 26.07.2022.
//

import UIKit
import Quick
import Nimble
@testable import PinchableGridLayoutDemo

class GridViewControllerSpec: QuickSpec {

    override func spec() {

        describe("Initial setup") {

            it("Adds pinch gesture recognizer to collection view") {
                let vc = GridViewController()
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
                vc.collectionView = collectionView

                vc.viewDidLoad()

                expect(collectionView.gestureRecognizers).to(containElementSatisfying { $0 is UIPinchGestureRecognizer })
            }
        }

        describe("User interaction") {

            it("Resets to default values") {
                let vc = GridViewController()

                let expectedRowSizes = type(of: vc).defaultRowSizes
                let expectedColumnSizes = type(of: vc).defaultColumnSizes

                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
                vc.collectionView = collectionView

                vc.columnSizes = [1, 2, 3]
                vc.rowSizes = [1, 2, 3, 4]

                vc.handleRefreshItemTap(UIBarButtonItem())

                expect(vc.columnSizes).to(equal(expectedColumnSizes))
                expect(vc.rowSizes).to(equal(expectedRowSizes))
                expect(collectionView.collectionViewLayout).to(beAnInstanceOf(GridLayout.self))
            }

            it("Recognizes pinch resture") {}
        }
    }

}
