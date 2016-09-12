//
//  PopUpViewController.swift
//  
//
//  Created by Erhies Fekarurhobo on 2016-07-17.
//
//

import UIKit



class PopUpViewController: UIViewController{
    var vc = ViewController()
 
    @IBOutlet weak var popUpView: UIView!

   
    @IBAction func closePopUp(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("reloadiCarousel", object: nil)
        self.view.removeFromSuperview()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        popUpView.layer.cornerRadius = 11.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
   
}
