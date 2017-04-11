//
//  DetailViewController.swift
//  Pinder
//
//  Created by Kate Harline on 4/10/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "detailToMatches", sender: nil)
    }
    
    @IBAction func settingPress(_ sender: Any) {
        performSegue(withIdentifier: "detailToSettings", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
