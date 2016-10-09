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

   
    @IBAction func closePopUp(_ sender: AnyObject) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removePopUP"), object: nil)
        self.view.removeFromSuperview()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        popUpView.layer.cornerRadius = 15.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
   
}
