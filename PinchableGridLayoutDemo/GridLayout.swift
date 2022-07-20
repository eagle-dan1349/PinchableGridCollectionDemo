//
//  GridLayout.swift
//  PinchableGridLayoutDemo
//
//  Created by Daniil Orlov on 18.07.2022.
//

import UIKit

class GridLayout: UICollectionViewLayout {

    var columnSizes: [CGFloat] {
        get { _columnSizes }
        set {
            assert(newValue.count > 0)
            _columnSizes = newValue
            columnRanges = calculateRanges(fromFractionalSizes: _columnSizes)
            invalidateLayout()
        }
    }

    var rowSizes: [CGFloat] {
        get { _rowSizes }
        set {
            assert(newValue.count > 0)
            _rowSizes = newValue
            rowRanges = calculateRanges(fromFractionalSizes: _rowSizes)
            invalidateLayout()
        }
    }

    private var _columnSizes = [CGFloat]()
    private var _rowSizes = [CGFloat]()

    private var columnRanges = [Range<CGFloat>]()
    private var rowRanges = [Range<CGFloat>]()

    private var layoutAttributesCache = NSCache<NSIndexPath, UICollectionViewLayoutAttributes>()
    private var contentSize: CGSize = .zero

    // MARK: - Grid API
    func set(columnSizes newColumnSizes: [CGFloat], rowSizes newRowSizes: [CGFloat]) {
        assert(newColumnSizes.count > 0)
        assert(newRowSizes.count > 0)
        _columnSizes = newColumnSizes
        _rowSizes = newRowSizes
        columnRanges = calculateRanges(fromFractionalSizes: _columnSizes)
        rowRanges = calculateRanges(fromFractionalSizes: _rowSizes)
        invalidateLayout()
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
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let cachedAttributes = layoutAttributesCache.object(forKey: indexPath as NSIndexPath) { return cachedAttributes }

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        let horizontalRange = columnRanges[indexPath.section]
        let verticalRange = rowRanges[indexPath.row]

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

        let startX = intersection.minX / contentSize.width
        let endX = intersection.maxX / contentSize.width
        let startY = intersection.minY / contentSize.height
        let endY = intersection.maxY / contentSize.height

        let initialColumn = columnRanges.firstIndex { $0.contains(startX) } ?? 0
        let finalColumn = columnRanges.firstIndex { $0.contains(endX) } ?? columnRanges.count
        let initialRow = rowRanges.firstIndex { $0.contains(startY) } ?? 0
        let finalRow = rowRanges.firstIndex { $0.contains(endY) } ?? rowRanges.count

        let rowRange = initialRow..<finalRow
        let columnRange = initialColumn..<finalColumn
        
        let indexPathsInIntersection = rowRange.reduce([]) { indexPaths, column in
            indexPaths + columnRange.map { IndexPath(item: $0, section: column) }
        }

        let attributes = indexPathsInIntersection.compactMap(layoutAttributesForItem(at:))

        return attributes
    }

    override func invalidateLayout() {
        layoutAttributesCache.removeAllObjects()
        super.invalidateLayout()
    }

    // MARK: - Calculations
    private func calculateRanges(fromFractionalSizes fractionalSizes: [CGFloat]) -> [Range<CGFloat>] {
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
