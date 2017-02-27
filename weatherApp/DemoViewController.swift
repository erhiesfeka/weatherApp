//
//  DemoViewController.swift
//  weatherApp
//
//  Created by Erhies Fekarurhobo on 2017-02-26.
//  Copyright © 2017 ratatat. All rights reserved.
//

import UIKit
import expanding_collection

internal func Init<Type>(_ value : Type, block: (_ object: Type) -> Void) -> Type
{
    block(value)
    return value
}

class DemoViewController: ExpandingViewController {
    
  fileprivate var cellsIsOpen = [Bool]()

}


// MARK: life cicle
extension DemoViewController {
    
    override func viewDidLoad() {
        itemSize = CGSize(width: 250, height: 330)
        super.viewDidLoad()
        
        registerCell()
        addGestureToView(collectionView!)
      
    }
}

// MARK: Helpers

extension DemoViewController {
    
    fileprivate func registerCell() {
        
        let nib = UINib(nibName: String(describing: DemoCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: DemoCollectionViewCell.self))
}
    
    /*fileprivate func getViewController() -> ExpandingTableViewController {
        let storyboard = UIStoryboard(name: "MainStoryBoard", bundle: nil)
        let toViewController: ExpandingTableViewController = storyboard.instantiateViewController(withIdentifier: "DemoTableViewController") as! ExpandingTableViewController
        return toViewController
    }*/
    
    fileprivate func getViewController() -> ExpandingTableViewController {
        let storyboard = UIStoryboard(name: "MainStoryBoard", bundle: nil)
        let toViewController: DemoTableViewController = storyboard.instantiateViewController(withIdentifier: "DemoTableViewController") as! DemoTableViewController
        return toViewController
    }
    
}

// MARK: UICollectionViewDataSource

extension DemoViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? DemoCollectionViewCell else { return }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DemoCollectionViewCell
            , currentIndex == (indexPath as NSIndexPath).row else { return }
        
        if cell.isOpened == false {
            cell.cellIsOpen(true)
        } else {
            pushToViewController(getViewController())
    
        }
    }
}

// MARK: UICollectionViewDataSource
extension DemoViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DemoCollectionViewCell.self), for: indexPath)
    }
}

/// MARK: Gesture


// MARK: Gesture

extension DemoViewController {
    
    fileprivate func addGestureToView(_ toView: UIView) {
        let gesutereUp = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
            $0.direction = .up
        }
        
        let gesutereDown = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        toView.addGestureRecognizer(gesutereUp)
        toView.addGestureRecognizer(gesutereDown)
        print("gestures added")
    }
    
    func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        print("in swipe handler")
        if sender.direction == .up {
            
            print( "Up Gesture Recognized")
        }else{
            print("Down Gesture recognized")
        }
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell  = collectionView?.cellForItem(at: indexPath) as? DemoCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            pushToViewController(getViewController())
            
        }
        
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        //cellsIsOpen[(indexPath as NSIndexPath).row] = cell.isOpened
    }
}


