//
//  PopUpViewController.swift
//  
//
//  Created by Erhies Fekarurhobo on 2016-07-17.
//
//

import UIKit

class PopUpViewController: UIViewController {

   
    @IBAction func closePopUp(sender: AnyObject) {
        
        self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
