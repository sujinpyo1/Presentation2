//
//  SlideViewController.swift
//  W13
//
//  Created by SWUCOMPUTER on 2018. 5. 25..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class SlideViewController: UIViewController {
    
    var menuShowing = false

    @IBOutlet var LeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
    }
   
    @IBAction func openMenu(_ sender: Any) {
        if(menuShowing) {
            LeadingConstraint.constant = -180
        } else {
            LeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.2, delay: 0.0 , options: .curveEaseIn, animations:
                {
                    self.view.layoutIfNeeded()
            })
        }
        menuShowing = !menuShowing
    }
    
}
