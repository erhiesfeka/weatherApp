//
//  MyExpandingViewController.swift
//  
//
//  Created by Erhies Fekarurhobo on 2017-02-24.
//
//

import UIKit
import expanding_collection

class MyExpandingViewController: ExpandingViewController {

    override func viewDidLoad() {
        
        itemSize = CGSize(width: 265, height: 279)
        super.viewDidLoad()
        
        // register cell
        let nib = UINib(nibName: "FrontView", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "collectionCell")
        if collectionView == nil {
            print("No such collection view")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



// MARK: UICollectionViewDataSource
extension MyExpandingViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        return cell
       
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! FrontView
       /* if cell.isOpened == true {
            let tvc: ExpandingTableViewController = ExpandingDeckTableViewController(style: .Plain)
            pushToViewController(tvc)
        }*/
        cell.cellIsOpen(!cell.isOpened)
    }
}
