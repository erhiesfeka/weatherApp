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
    // @IBAction func close(_ sender: Any) {
    // }
    
    typealias ItemInfo = (imageName: String, title: String)
    fileprivate var cellsIsOpen = [Bool]()
   // fileprivate let items: [ItemInfo] = [("item0", "Boston"),("item1", "New York"),("item2", "San Francisco"),("item3", "Washington")]
    fileprivate let items: [ItemInfo] = [("rain", "rain.jpg"),("rain.jpg", "rain.jpg"),("rain.jpg", "rain.jpg"),("rain.jpg", "rain.jpg")]
    
}


// MARK: life cicle
extension DemoViewController {
    
    override func viewDidLoad() {
        itemSize = CGSize(width: 260, height: 350)
        super.viewDidLoad()
        fillCellIsOpeenArry()
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
    
    fileprivate func fillCellIsOpeenArry() {
        for _ in items {
            cellsIsOpen.append(false)
        }
    }
    
    fileprivate func getViewController() -> ExpandingTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let toViewController: DemoTableViewController  = (storyboard.instantiateViewController(withIdentifier: "DemoTableViewController") as? DemoTableViewController)!
        
        return toViewController
    }
    
    
}

/// MARK: Gesture
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
        cellsIsOpen[(indexPath as NSIndexPath).row] = cell.isOpened
    }
}

// MARK: UIScrollViewDelegate

extension DemoViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // pageLabel.text = "\(currentIndex+1)/\(items.count)"
    }
}

// MARK: UICollectionViewDataSource

extension DemoViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? DemoCollectionViewCell else { return }
        
        let index = (indexPath as NSIndexPath).row % items.count
        let info = items[index]
        
        cell.backgroundImageView?.image = UIImage(named: info.imageName)
        
        //cell.customTitle.text = info.title
        cell.cellIsOpen(cellsIsOpen[index], animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DemoCollectionViewCell
            , currentIndex == (indexPath as NSIndexPath).row else { return }
        
        if cell.isOpened == false {
            cell.cellIsOpen(true)
        } else {
            pushToViewController(getViewController())
            
            // if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
            //  rightButton.animationSelected(true)
            // }
        }
    }
}

// MARK: UICollectionViewDataSource
extension DemoViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DemoCollectionViewCell.self), for: indexPath)
    }
}


