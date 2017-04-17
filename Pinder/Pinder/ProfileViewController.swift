//
//  ProfileViewController.swift
//  Pinder
//
//  Created by Kate Harline on 4/10/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "toBrowse", sender: nil)
    }
    
    func loadData() {
        interestLabel.font = UIFont(name: "QuicksandDash-Regular", size: 16)
        locationLabel.font = UIFont(name: "QuicksandDash-Regular", size: 16)
        timesLabel.font = UIFont(name: "QuicksandDash-Regular", size: 16)
        contactLabel.font = UIFont(name: "QuicksandDash-Regular", size: 16)
        nameLabel.font = UIFont(name: "QuicksandDash-Regular", size: 16)
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
