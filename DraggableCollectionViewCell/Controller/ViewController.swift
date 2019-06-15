//
//  ViewController.swift
//  DraggableCollectionViewCell
//
//  Created by Rushabh Shah on 15/06/19.
//  Copyright © 2019 Rushabh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    //MARK:
    //MARK: Outlet declaration
    @IBOutlet weak var draggableCollection: UICollectionView!
    
    //MARK:
    //MARK: Variable declaration

    var strArr: [Character] = ("A"..."Z").characters
    
    fileprivate var longPress: UILongPressGestureRecognizer!
    
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressGesture(gesture:)))
        draggableCollection.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer){
        switch (gesture.state) {
        case .began:
            guard let selectedIndexPath = draggableCollection.indexPathForItem(at: gesture.location(in: draggableCollection)) else {
                break
            }
            draggableCollection.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            draggableCollection.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            draggableCollection.endInteractiveMovement()
        default:
            draggableCollection.cancelInteractiveMovement()
        }
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return strArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DraggableCollectionViewCell
        cell?.lblNumber.text = String(strArr[indexPath.row])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/4, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = strArr.remove(at: sourceIndexPath.item)
        strArr.insert(item, at: destinationIndexPath.item)
    }
}

extension Character: Strideable {
    public typealias Stride = Int
    
    public func distance(to other: Character) -> Character.Stride {
        let stride = Int(String(self).unicodeScalars.first!.value) - Int(String(other).unicodeScalars.first!.value)
        return abs(stride)
    }
    
    public func advanced(by n: Character.Stride) -> Character {
        return Character(UnicodeScalar(String(self).unicodeScalars.first!.value + UInt32(n))!)
    }
}

extension ClosedRange where Element == Character {
    
    var characters: [Character] { return Array(self) }
}
