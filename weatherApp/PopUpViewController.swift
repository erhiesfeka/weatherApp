//
//  PopUpViewController.swift
//  
//
//  Created by Erhies Fekarurhobo on 2016-07-17.
//
//

import UIKit
import GooglePlaces



class PopUpViewController: UIViewController{
    var vc = ViewController()
 
    @IBOutlet weak var popUpView: UIView!

   
    @IBAction func closePopUp(_ sender: AnyObject) {
     self.clickClose()
    }
    
    func clickClose(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadiCarousel"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removePopUP"), object: nil)
        self.view.removeFromSuperview()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(PopUpViewController.clickClose), name: NSNotification.Name(rawValue: "clickClose"), object: nil)
         self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
        popUpView.layer.cornerRadius = 15.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
   
}
