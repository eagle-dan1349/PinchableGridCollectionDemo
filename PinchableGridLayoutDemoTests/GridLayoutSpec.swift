//
//  GridLayoutSpec.swift
//  PinchableGridLayoutDemoTests
//
//  Created by Daniil Orlov on 25.07.2022.
//

import UIKit
import Quick
import Nimble
@testable import PinchableGridLayoutDemo

class GridLayoutSpec: QuickSpec {

    // swiftlint:disable_next function_body_length
    override func spec() {

        describe("Initialization") {

            it("Initializes") {
                expect {
                    _ = GridLayout()
                }.toNot(throwError())
            }

            it("Initializes conveniencely") {
                expect {
                    _ = GridLayout(columnSizes: [1, 2, 3], rowSizes: [1, 2, 3])
                }.toNot(throwError())
            }
        }

        describe("Expected errors") {

            context("Given invalid row input data") {

                let gridLayout = GridLayout()

                it("throws invalid argument error for empty `rowSizes`") {
                    expect {
                        try gridLayout.set(rowSizes: [])
                    }.to(throwError(GridLayout.Errors.invalidArgument))
                }

                it("throws invalid argument error for non-positive `rowSizes`") {
                    expect {
                        try gridLayout.set(rowSizes: [1, -1, 12])
                    }.to(throwError(GridLayout.Errors.invalidArgument))
                }

                it("keeps `rowRanges` unchanged for invalid new `rowSizes`") {
                    let oldRowRanges = gridLayout.rowRanges
                    try? gridLayout.set(rowSizes: [])

                    expect(gridLayout.rowRanges).to(equal(oldRowRanges))
                }
            }

            context("Given invalid column input data") {

                let gridLayout = GridLayout()

                it("throws invalid argument error for empty `columnSizes`") {
                    expect {
                        try gridLayout.set(columnSizes: [])
                    }.to(throwError(GridLayout.Errors.invalidArgument))
                }

                it("throws invalid argument error for non-positive `columnSizes`") {
                    expect {
                        try gridLayout.set(columnSizes: [1, -1, 12])
                    }.to(throwError(GridLayout.Errors.invalidArgument))
                }

                it("keeps `columnRanges` unchanged for invalid new `rowSizes`") {
                    let oldColumnRanges = gridLayout.columnRanges
                    try? gridLayout.set(columnSizes: [])

                    expect(gridLayout.rowRanges).to(equal(oldColumnRanges))
                }
            }

            context("Given invalid input data") {

                let gridLayout = GridLayout()

                it("throws invalid argument error for empty `columnSizes`") {
                    expect {
                        try gridLayout.set(columnSizes: [], rowSizes: [1, 1, 1])
                    }.to(throwError(GridLayout.Errors.invalidArgument))
                }

                it("throws invalid argument error for non-positive `columnSizes`") {
                    expect {
                        try gridLayout.set(columnSizes: [1, -1, 12], rowSizes: [1, 1, 1])
                    }.to(throwError(GridLayout.Errors.invalidArgument))
                }

                it("throws invalid argument error for empty `rowSizes`") {
                    expect {
                        try gridLayout.set(columnSizes: [1, 1, 1], rowSizes: [])
                    }.to(throwError(GridLayout.Errors.invalidArgument))
                }

                it("throws invalid argument error for non-positive `rowSizes`") {
                    expect {
                        try gridLayout.set(columnSizes: [1, 1, 1], rowSizes: [1, -1, 12])
                    }.to(throwError(GridLayout.Errors.invalidArgument))
                }

                it("keeps `rowRanges` unchanged for invalid new `rowSizes`") {
                    let oldRowRanges = gridLayout.rowRanges
                    try? gridLayout.set(rowSizes: [])

                    expect(gridLayout.rowRanges).to(equal(oldRowRanges))
                }

                it("keeps `columnRanges` unchanged for invalid new `rowSizes`") {
                    let oldColumnRanges = gridLayout.columnRanges
                    try? gridLayout.set(columnSizes: [])

                    expect(gridLayout.rowRanges).to(equal(oldColumnRanges))
                }
            }
        }

        describe("Calculations") {

            it("skips calculation when new rowSizes equal to old") {
                let gridLayout = GridLayout()
                let oldRowRanges = gridLayout.rowRanges
                try? gridLayout.set(rowSizes: [1, 1, 1])
                expect(gridLayout.rowRanges).to(equal(oldRowRanges))
            }

            it("recalculates rowRanges when rowSizes change") {
                let gridLayout = GridLayout()
                let rowSizes: [CGFloat] = [1, 2, 3]
                let expectedRanges: [Range<CGFloat>] = [
                    Range(uncheckedBounds: (0, 1.0 / 6.0)),
                    Range(uncheckedBounds: (1.0 / 6.0, 3.0 / 6.0)),
                    Range(uncheckedBounds: (3.0 / 6.0, 6.0 / 6.0))
                ]
                try? gridLayout.set(rowSizes: rowSizes)
                expect(gridLayout.rowRanges).to(equal(expectedRanges))
            }

            it("recalculates rowRanges when setting both sizes") {
                let gridLayout = GridLayout()
                let rowSizes: [CGFloat] = [1, 2, 3]
                let oldColumnRanges = gridLayout.columnRanges
                let expectedRanges: [Range<CGFloat>] = [
                    Range(uncheckedBounds: (0, 1.0 / 6.0)),
                    Range(uncheckedBounds: (1.0 / 6.0, 3.0 / 6.0)),
                    Range(uncheckedBounds: (3.0 / 6.0, 6.0 / 6.0))
                ]
                try? gridLayout.set(columnSizes: [1, 1, 1], rowSizes: rowSizes)
                expect(gridLayout.rowRanges).to(equal(expectedRanges))
                expect(gridLayout.columnRanges).to(equal(oldColumnRanges))
            }

            it("skips calculation when new columnSizes equal to old") {
                let gridLayout = GridLayout()
                let oldColumnRanges = gridLayout.columnRanges
                try? gridLayout.set(columnSizes: [1, 1, 1])
                expect(gridLayout.columnRanges).to(equal(oldColumnRanges))
            }

            it("recalculates columnRanges when columnSizes change") {
                let gridLayout = GridLayout()
                let columnSizes: [CGFloat] = [1, 2, 3]
                let expectedRanges: [Range<CGFloat>] = [
                    Range(uncheckedBounds: (0, 1.0 / 6.0)),
                    Range(uncheckedBounds: (1.0 / 6.0, 3.0 / 6.0)),
                    Range(uncheckedBounds: (3.0 / 6.0, 6.0 / 6.0))
                ]
                try? gridLayout.set(columnSizes: columnSizes)
                expect(gridLayout.columnRanges).to(equal(expectedRanges))
            }

            it("recalculates columnRanges when both sizes change") {
                let gridLayout = GridLayout()
                let columnSizes: [CGFloat] = [1, 2, 3]
                let expectedRanges: [Range<CGFloat>] = [
                    Range(uncheckedBounds: (0, 1.0 / 6.0)),
                    Range(uncheckedBounds: (1.0 / 6.0, 3.0 / 6.0)),
                    Range(uncheckedBounds: (3.0 / 6.0, 6.0 / 6.0))
                ]
                let oldRowRanges = gridLayout.rowRanges
                try? gridLayout.set(columnSizes: columnSizes, rowSizes: [1, 1, 1])
                expect(gridLayout.columnRanges).to(equal(expectedRanges))
                expect(gridLayout.rowRanges).to(equal(oldRowRanges))
            }

            it("recalculates columnRanges and rowRanges when both sizes change") {
                let gridLayout = GridLayout()
                let columnSizes: [CGFloat] = [1, 2, 3]
                let expectedColumnRanges: [Range<CGFloat>] = [
                    Range(uncheckedBounds: (0, 1.0 / 6.0)),
                    Range(uncheckedBounds: (1.0 / 6.0, 3.0 / 6.0)),
                    Range(uncheckedBounds: (3.0 / 6.0, 6.0 / 6.0))
                ]
                let rowSizes: [CGFloat] = [1, 2, 3]
                let expectedRowRanges: [Range<CGFloat>] = [
                    Range(uncheckedBounds: (0, 1.0 / 6.0)),
                    Range(uncheckedBounds: (1.0 / 6.0, 3.0 / 6.0)),
                    Range(uncheckedBounds: (3.0 / 6.0, 6.0 / 6.0))
                ]
                try? gridLayout.set(columnSizes: columnSizes, rowSizes: rowSizes)
                expect(gridLayout.columnRanges).to(equal(expectedColumnRanges))
                expect(gridLayout.rowRanges).to(equal(expectedRowRanges))
            }

            it("skips calculation when new columnSizes and rowSizes equal to old") {
                let gridLayout = GridLayout()
                let oldColumnRanges = gridLayout.columnRanges
                let oldRowRanges = gridLayout.rowRanges
                try? gridLayout.set(columnSizes: [1, 1, 1], rowSizes: [1, 1, 1])
                expect(gridLayout.columnRanges).to(equal(oldColumnRanges))
                expect(gridLayout.rowRanges).to(equal(oldRowRanges))
            }
        }

        describe("UICollectionViewLayout functionality") {

            context("`contentSize` calculation") {

                it("Calculates correct `contentSize` for Colelction View") {
                    let gridLayout = GridLayout()
                    let collectionFrame = CGRect(x: 20, y: 15, width: 200, height: 500)
                    let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: gridLayout)
                    gridLayout.prepare()
                    collectionView.frame = collectionFrame

                    expect(gridLayout.contentSize).to(equal(collectionFrame.size))
                }

                it("Respects `contentInsets` of CollectionView") {
                    let gridLayout = GridLayout()
                    let collectionFrame = CGRect(x: 20, y: 15, width: 200, height: 500)
                    let insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
                    let expectedSize = collectionFrame.inset(by: insets).size
                    let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: gridLayout)
                    collectionView.contentInset = insets
                    gridLayout.prepare()

                    expect(gridLayout.contentSize).to(equal(expectedSize))
                }
            }

            context("Layout attributes calculation") {

                it("calculates expected frames for layout attributes") {
                    let gridLayout = GridLayout()
                    let columnSizes: [CGFloat] = [1, 1, 1, 1]
                    let rowSizes: [CGFloat] = [1, 1, 1, 1]

                    try gridLayout.set(columnSizes: columnSizes, rowSizes: rowSizes)

                    let collectionWidth: CGFloat = 100
                    let collectionHeight: CGFloat = 100
                    let collectionFrame = CGRect(x: 0, y: 0, width: collectionWidth, height: collectionHeight)
                    let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: gridLayout)
                    gridLayout.prepare()
                    collectionView.frame = collectionFrame

                    for column in 0..<columnSizes.count {
                        for row in 0..<rowSizes.count {
                            let indexPath = IndexPath(item: column, section: row)
                            let attributes = gridLayout.layoutAttributesForItem(at: indexPath)

                            let expectedX = collectionWidth / CGFloat(columnSizes.count) * CGFloat(column)
                            let expectedY = collectionHeight / CGFloat(rowSizes.count) * CGFloat(row)
                            let expectedW = collectionWidth / CGFloat(columnSizes.count)
                            let expectedH = collectionHeight / CGFloat(rowSizes.count)

                            expect(attributes?.frame.origin.x).to(beCloseTo(expectedX, within: 0.001))
                            expect(attributes?.frame.origin.y).to(beCloseTo(expectedY, within: 0.001))
                            expect(attributes?.frame.size.width).to(beCloseTo(expectedW, within: 0.001))
                            expect(attributes?.frame.size.height).to(beCloseTo(expectedH, within: 0.001))
                        }
                    }
                }

                it("Provides attributes from cache") {
                    let gridLayout = GridLayout()
                    let columnSizes: [CGFloat] = [1, 1, 1, 1]
                    let rowSizes: [CGFloat] = [1, 1, 1, 1]

                    try gridLayout.set(columnSizes: columnSizes, rowSizes: rowSizes)

                    let collectionWidth: CGFloat = 100
                    let collectionHeight: CGFloat = 100
                    let collectionFrame = CGRect(x: 0, y: 0, width: collectionWidth, height: collectionHeight)
                    let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: gridLayout)
                    gridLayout.prepare()
                    collectionView.frame = collectionFrame

                    let indexPath = IndexPath(item: 2, section: 3)
                    let firstAttributes = gridLayout.layoutAttributesForItem(at: indexPath)
                    let secondAttributes = gridLayout.layoutAttributesForItem(at: indexPath)

                    expect(firstAttributes).to(equal(secondAttributes))
                }

                it("Discards cached attributes when grid setup changes") {
                    let gridLayout = GridLayout()
                    let columnSizes: [CGFloat] = [1, 1, 1, 1]
                    let rowSizes: [CGFloat] = [1, 1, 1, 1]

                    let collectionWidth: CGFloat = 100
                    let collectionHeight: CGFloat = 100
                    let collectionFrame = CGRect(x: 0, y: 0, width: collectionWidth, height: collectionHeight)
                    let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: gridLayout)
                    gridLayout.prepare()
                    collectionView.frame = collectionFrame

                    let indexPath = IndexPath(item: 2, section: 2)
                    let firstAttributes = gridLayout.layoutAttributesForItem(at: indexPath)
                    try gridLayout.set(columnSizes: columnSizes, rowSizes: rowSizes)
                    let secondAttributes = gridLayout.layoutAttributesForItem(at: indexPath)

                    expect(firstAttributes).toNot(equal(secondAttributes))
                }
            }
        }

        describe("Edge-cases") {

            it("skips preparation given no collectionView") {
                let gridLayout = GridLayout()
                gridLayout.prepare()

                expect(gridLayout.collectionViewContentSize).to(equal(.zero))
                expect(gridLayout.columnRanges).to(beEmpty())
                expect(gridLayout.rowRanges).to(beEmpty())
            }

            it("returns no layout attributes for zero `rect`") {
                let gridLayout = GridLayout()
                let collectionFrame = CGRect(x: 20, y: 15, width: 200, height: 500)
                let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: gridLayout)
                gridLayout.prepare()
                collectionView.frame = collectionFrame

                let layoutAttributes = gridLayout.layoutAttributesForElements(in: .zero)

                expect(layoutAttributes).to(beNil())
            }

            it("returns no layout for zero `contentSize`") {
                let gridLayout = GridLayout()
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
                gridLayout.prepare()
                collectionView.frame = .zero

                let indexPath = IndexPath(item: 1, section: 2)
                let layoutAttributes = gridLayout.layoutAttributesForItem(at: indexPath)

                expect(layoutAttributes).to(beNil())
            }

            it("returns no layout attributes for items outside the grid") {
                let gridLayout = GridLayout()
                let collectionFrame = CGRect(x: 20, y: 15, width: 200, height: 500)
                let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: gridLayout)
                gridLayout.prepare()
                collectionView.frame = collectionFrame

                let indexPath = IndexPath(item: gridLayout.columnSizes.count, section: gridLayout.rowSizes.count)
                let layoutAttributes = gridLayout.layoutAttributesForItem(at: indexPath)

                expect(layoutAttributes).to(beNil())
            }

            it("adequately handles rects greater than collection view frame") {
                let gridLayout = GridLayout()
                let collectionFrame = CGRect(x: 20, y: 15, width: 200, height: 500)
                let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: gridLayout)
                gridLayout.prepare()
                collectionView.frame = collectionFrame

                let testRect = collectionFrame.insetBy(dx: -100, dy: -150)

                let layoutAttributes = gridLayout.layoutAttributesForElements(in: testRect)

                expect(layoutAttributes).toNot(beNil())
                expect(layoutAttributes).toNot(beEmpty())
            }
        }
    }
}
