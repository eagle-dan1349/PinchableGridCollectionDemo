//
//  GridLayout.swift
//  PinchableGridLayoutDemo
//
//  Created by Daniil Orlov on 18.07.2022.
//

import UIKit

/**
 This `GridLayout` implements a rectangular grid with proportional cells spanning entire bounds of collection view.
 `columnSizes` and `rowSizes` represent desired relative sizes of columns and rows respectively.
 The `GridLayout` will treat rows as sections and coulmns as items for building `IndexPath`s
 e.g. setup with 3 columns and 2 rows will result in 2 sections with 3 items each.
 Make sure that `UIColelctionViewDataSource` has the same number or sections and items,
 otherwise items beyond configured rows and columns will be ignored.
 */
class GridLayout: UICollectionViewLayout {

    enum Errors: Error {
        case invalidArgument
    }

    /**
     Desired relative sizes for grid columns.
     */
    private(set) var columnSizes: [CGFloat] = [1, 1, 1]

    /**
     Desired relative sizes for grid rows. This array is expected to contain one or more positive number.
     */
    private(set) var rowSizes: [CGFloat] = [1, 1, 1]

    var columnRanges = [Range<CGFloat>]()
    var rowRanges = [Range<CGFloat>]()

    var layoutAttributesCache = NSCache<NSIndexPath, UICollectionViewLayoutAttributes>()
    var contentSize: CGSize = .zero

    // MARK: - Initialization
    convenience init(columnSizes: [CGFloat], rowSizes: [CGFloat]) {
        self.init()

        self.columnSizes = columnSizes
        self.rowSizes = rowSizes
    }

    // MARK: - The Grid API

    /**
     Sets desired relative sizes for grid columns. Calling this method with `newColumnSizes` different from current will invalidate the layout and trigger collection view to adjust as a result.
     - parameter newColumnSizes: Desired relative sizes of columns. This array is expected to contain one or more positive number.
     - throws: `GridLayout.Errors.invalidArgument` if `newColumnSizes` is empty or contains non-positive numbers.
     */
    func set(columnSizes newColumnSizes: [CGFloat]) throws {
        guard !newColumnSizes.isEmpty else { throw Errors.invalidArgument }
        guard !newColumnSizes.contains(where: { $0 < 0 }) else { throw Errors.invalidArgument }

        guard newColumnSizes != columnSizes else { return }

        columnSizes = newColumnSizes
        calculateColumnRanges()
        invalidateLayout()
    }

    /**
     Sets desired relative sizes for grid rows. Calling this method with `newRowSizes` different from current will invalidate the layout and trigger collection view to adjust as a result.
     - parameter newColumnSizes: Desired relative sizes of columns. This array is expected to contain one or more positive number.
     - throws: `GridLayout.Errors.invalidArgument` if `newRowSizes` is empty or contains non-positive numbers.
     */
    func set(rowSizes newRowSizes: [CGFloat]) throws {
        guard !newRowSizes.isEmpty else { throw Errors.invalidArgument }
        guard !newRowSizes.contains(where: { $0 < 0 }) else { throw Errors.invalidArgument }

        guard newRowSizes != rowSizes else { return }

        rowSizes = newRowSizes
        calculateRowRanges()
        invalidateLayout()
    }

    /**
     Sets desired relative sizes for both grid columns and rows.
     Calling this method with `newRowSizes` or `newColumnSizes` different from current will invalidate the layout and trigger collection view to adjust as a result.
     - parameter newColumnSizes: Desired relative sizes of columns. This array is expected to contain one or more positive number.
     - parameter newColumnSizes: Desired relative sizes of columns. This array is expected to contain one or more positive number.
     - throws: `GridLayout.Errors.invalidArgument` if `newColumnSizes` or `newRowSizes` is empty or contains non-positive numbers.
     */
    func set(columnSizes newColumnSizes: [CGFloat], rowSizes newRowSizes: [CGFloat]) throws {
        guard !newColumnSizes.isEmpty else { throw Errors.invalidArgument }
        guard !newColumnSizes.contains(where: { $0 < 0 }) else { throw Errors.invalidArgument }

        guard !newRowSizes.isEmpty else { throw Errors.invalidArgument }
        guard !newRowSizes.contains(where: { $0 < 0 }) else { throw Errors.invalidArgument }

        if newColumnSizes != columnSizes {
            columnSizes = newColumnSizes
            calculateColumnRanges()
            invalidateLayout()
        }

        if newRowSizes != rowSizes {
            rowSizes = newRowSizes
            calculateRowRanges()
            invalidateLayout()
        }
    }

    // MARK: - UICollectionViewLayout core properties
    override var collectionViewContentSize: CGSize { contentSize }

    // MARK: - UICollectionViewLayout core methods
    override func prepare() {
        guard let collectionView = collectionView else { return }

        contentSize =
        collectionView.bounds
            .inset(by: collectionView.contentInset)
            .inset(by: collectionView.safeAreaInsets)
            .size

        calculateColumnRanges()
        calculateRowRanges()
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard contentSize.width > 0, contentSize.height > 0 else { return nil }
        guard indexPath.section < rowRanges.count, indexPath.item < columnRanges.count else { return nil }

        if let cachedAttributes = layoutAttributesCache.object(forKey: indexPath as NSIndexPath) { return cachedAttributes }

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        let verticalRange = rowRanges[indexPath.section]
        let horizontalRange = columnRanges[indexPath.row]

        let x = horizontalRange.lowerBound * contentSize.width
        let y = verticalRange.lowerBound * contentSize.height
        let w = horizontalRange.upperBound * contentSize.width - x
        let h = verticalRange.upperBound * contentSize.height - y

        attributes.frame = CGRect(x: x, y: y, width: w, height: h)

        layoutAttributesCache.setObject(attributes, forKey: indexPath as NSIndexPath)

        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let intersection = CGRect(origin: .zero, size: contentSize).intersection(rect)
        guard !intersection.isEmpty else { return nil }
        guard !rowRanges.isEmpty, !columnRanges.isEmpty else { return nil }

        // normalized coordinates of intersection
        let startX = intersection.minX / contentSize.width
        let endX = intersection.maxX / contentSize.width
        let startY = intersection.minY / contentSize.height
        let endY = intersection.maxY / contentSize.height

        // row and column indices caught in intersection
        let initialColumn = columnRanges.firstIndex { $0.contains(startX) } ?? 0
        let finalColumn = columnRanges.lastIndex { $0.contains(endX) } ?? columnRanges.count
        let initialRow = rowRanges.firstIndex { $0.contains(startY) } ?? 0
        let finalRow = rowRanges.lastIndex { $0.contains(endY) } ?? rowRanges.count

        let rowRange = initialRow..<finalRow
        let columnRange = initialColumn..<finalColumn

        let attributes = rowRange.reduce([]) { attrs, column in
            attrs + columnRange.compactMap({ row in
                layoutAttributesForItem(at: IndexPath(item: column, section: row))
            })
        }

        return attributes
    }

    override func invalidateLayout() {
        layoutAttributesCache.removeAllObjects()
        super.invalidateLayout()
    }

    // MARK: - Calculations

    /**
     Recalculates column ranges for grid. Make sure to invalidate layout after calling this.
     */
    func calculateColumnRanges() {
        columnRanges = type(of: self).calculateRanges(fromFractionalSizes: columnSizes)
    }

    /**
     Recalculates row ranges for grid. Make sure to invalidate layout after calling this.
     */
    func calculateRowRanges() {
        rowRanges = type(of: self).calculateRanges(fromFractionalSizes: rowSizes)
    }

    /**
     `GridLayout` uses `Range<Float>` as underlying data model that represents grid configuration.
     This method transforms relative sizes of grid rows/columns provided by user to ranges that represent _normalized_ beginning  and end of cells.
     After that these ranges are used to calculate `x`, `y`, `width`, and `height` of corresponding cells in `layoutAttributesForItem(at:)`
     - parameter fractionalSizes: `columnSizes` or `rowSizes`. The input array MUST be not empty and contain only non-positive numbers for meaningful results.
     - returns: Array of ranges representing _normalized_ beggining/end coordinates of cell frames in columns/rows
     */
    class func calculateRanges(fromFractionalSizes fractionalSizes: [CGFloat]) -> [Range<CGFloat>] {
        let totalSize = fractionalSizes.reduce(0, +)

        var start: CGFloat = 0.0
        return fractionalSizes.map { fractionSize in
            let end = start + fractionSize / totalSize
            let range = Range(uncheckedBounds: (start, end))
            start = end
            return range
        }
    }
}
