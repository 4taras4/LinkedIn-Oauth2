//
//  ViewController.swift
//  LinkedIn-Oauth
//
//  Created by Taras on 12/15/17.
//  Copyright © 2017 Taras. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func loginAction(_ sender: Any) {
        let controller = WebOauthViewController()
          self.present(controller, animated: false, completion: nil)
    }
    @IBOutlet weak var tokenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
   

}

