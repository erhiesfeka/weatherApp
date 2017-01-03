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

    @IBOutlet weak var settingsLabel: UILabel!
   
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
        let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: popUpView.frame.width , height: popUpView.frame.height * 0.4),
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 15, height: 15))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        
        settingsLabel.frame = maskPath.bounds
        settingsLabel.layer.masksToBounds = true
      //  settingsLabel.contentMode = .scaleToFill
        settingsLabel.layer.mask = shape
        
        
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
