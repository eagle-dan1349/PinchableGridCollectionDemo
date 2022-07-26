//
//  GridViewController.swift
//  PinchableGridLayoutDemo
//
//  Created by Daniil Orlov on 18.07.2022.
//

import UIKit

class GridViewController: UICollectionViewController {

    static let cellId = "GridLayoutDemo.cellId"

    static let defaultColumnSizes: [CGFloat] = [1, 1, 1]
    static let defaultRowSizes: [CGFloat] = [1, 1, 1]

    static let minCellSize = 0.5
    static let maxCellSize = 2.0

    var columnSizes: [CGFloat] = [1, 1, 1]
    var rowSizes: [CGFloat] = [1, 1, 1]

    override func viewDidLoad() {
        super.viewDidLoad()

        if let gridLayout = collectionView.collectionViewLayout as? GridLayout {
            try? gridLayout.set(columnSizes: columnSizes, rowSizes: rowSizes)
        }

        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(recognizePinchGesture(from:)))

        collectionView.addGestureRecognizer(gestureRecognizer)
    }

    @objc func recognizePinchGesture(from recognizer: UIPinchGestureRecognizer) {
        let location = recognizer.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return }
        guard let gridLayout = collectionView.collectionViewLayout as? GridLayout else { return }
        let scale = recognizer.scale

        columnSizes[indexPath.section] = clamp(columnSizes[indexPath.section] * scale, type(of: self).minCellSize, type(of: self).maxCellSize)
        rowSizes[indexPath.section] = clamp(rowSizes[indexPath.section] * scale, type(of: self).minCellSize, type(of: self).maxCellSize)

        try? gridLayout.set(columnSizes: columnSizes, rowSizes: rowSizes)

        recognizer.scale = 1
    }

    @IBAction func handleRefreshItemTap(_ sender: UIBarButtonItem) {
        columnSizes = type(of: self).defaultColumnSizes
        rowSizes = type(of: self).defaultRowSizes

        let gridLayout = GridLayout()
        try? gridLayout.set(columnSizes: columnSizes, rowSizes: rowSizes)

        collectionView.setCollectionViewLayout(gridLayout, animated: true)
    }
}

extension GridViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return columnSizes.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowSizes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridViewController.cellId, for: indexPath)
        return cell
    }
}
