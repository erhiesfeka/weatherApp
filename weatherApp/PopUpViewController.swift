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
    
    var settingsVc = SettingsViewController()
 
    @IBOutlet weak var popUpView: UIView!

    @IBOutlet weak var settingsLabel: UILabel!
   
    @IBOutlet weak var settingsContainerView: UIView!
    
    
    func clickClose(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadiCarousel"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removePopUP"), object: nil)
        self.view.removeFromSuperview()
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            if touch.view == self.view {
                self.clickClose()
            } else {
                return
            }
            
        }
        
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
        
        self.view.alpha = 0
        popUpView.alpha = 0
        settingsContainerView.alpha = 0
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            
             self.view.alpha = 1
             self.popUpView.alpha = 1
             self.settingsContainerView.alpha = 1
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
   
}
