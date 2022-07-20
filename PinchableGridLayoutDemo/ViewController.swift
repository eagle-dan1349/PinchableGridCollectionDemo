//
//  ViewController.swift
//  PinchableGridLayoutDemo
//
//  Created by Daniil Orlov on 18.07.2022.
//

import UIKit

class ViewController: UICollectionViewController {

    static let cellId = "GridLayoutDemo.cellId"

    var initialColumnSizes: [CGFloat] = [1, 1, 1]
    var initialRowSizes: [CGFloat] = [1, 1, 1]

    var newColumnSizes: [CGFloat] = [1, 1, 1]
    var newRowSizes: [CGFloat] = [1, 1, 1]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gridLayout = collectionView.collectionViewLayout as? GridLayout {
            gridLayout.columnSizes = initialColumnSizes
            gridLayout.rowSizes = initialRowSizes
        }

        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(recognizePinchGesture(from:)))

        collectionView.addGestureRecognizer(gestureRecognizer)
    }

    @objc func recognizePinchGesture(from recognizer: UIPinchGestureRecognizer) {
        let location = recognizer.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return }
        guard let gridLayout = collectionView.collectionViewLayout as? GridLayout else { return }
        let scale = recognizer.scale

        newColumnSizes[indexPath.section] = clamp(newColumnSizes[indexPath.section] * scale, 0.5, 2)
        newRowSizes[indexPath.section] = clamp(newRowSizes[indexPath.section] * scale, 0.5, 2)

        gridLayout.set(columnSizes: newColumnSizes, rowSizes: newRowSizes)
        
        self.initialColumnSizes = newColumnSizes
        self.initialRowSizes = newRowSizes

        recognizer.scale = 1
    }

    @IBAction func handleRefreshItemTap(_ sender: UIBarButtonItem) {
        initialColumnSizes = [1, 1, 1]
        initialRowSizes = [1, 1, 1]

        newColumnSizes = initialColumnSizes
        newRowSizes = initialRowSizes

        let gridLayout = GridLayout()
        gridLayout.set(columnSizes: newColumnSizes, rowSizes: newRowSizes)

        collectionView.setCollectionViewLayout(gridLayout, animated: true)
    }
}

extension ViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return initialColumnSizes.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return initialRowSizes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.cellId, for: indexPath)
        return cell
    }
}
