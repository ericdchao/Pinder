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
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "detailToMatches", sender: nil)
    }
    
    @IBAction func settingPress(_ sender: Any) {
        performSegue(withIdentifier: "detailToSettings", sender: nil)
    }
    
    func matchLoaded() {
        interestsLabel.font = UIFont(name: "QuicksandDash-Regular", size: 16)
        locationLabel.font = UIFont(name: "QuicksandDash-Regular", size: 16)
        timesLabel.font = UIFont(name: "QuicksandDash-Regular", size: 16)
        contactLabel.font = UIFont(name: "QuicksandDash-Regular", size: 16)
        nameLabel.font = UIFont(name: "QuicksandDash-Regular", size: 35)
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
