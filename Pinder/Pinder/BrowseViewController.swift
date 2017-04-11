//
//  MatchesViewController.swift
//  Pinder
//
//  Created by Kate Harline on 4/10/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

import UIKit
import Firebase

class BrowseViewController: UIViewController {

    @IBAction func matchPressed(_ sender: Any) {
        performSegue(withIdentifier: "toMatches", sender: nil)
    }
    @IBAction func settingPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: nil)
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
