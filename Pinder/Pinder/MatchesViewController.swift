//
//  MatchesViewControlle.swift
//  Pinder
//
//  Created by Kate Harline on 4/10/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

import UIKit
import Firebase

class MatchesViewController: UIViewController {
    
    @IBAction func browsePressed(_ sender: Any) {
        performSegue(withIdentifier: "toBrowseFromMatch", sender: nil)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSettingFromMatch", sender: nil)
    }

    @IBAction func matchSelected(_ sender: Any) {
        performSegue(withIdentifier: "toDetail", sender: nil)
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
