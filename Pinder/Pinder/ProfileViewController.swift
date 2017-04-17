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
    var userToDisplay : String = ""
    
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    
    
    @IBOutlet weak var image: UIImageView!
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "toBrowse", sender: nil)
    }
    @IBAction func editPressed(_ sender: Any) {
        performSegue(withIdentifier: "settingsToEdit", sender: nil)
    }
   
    
    func loadData() {
        interestsLabel.font = UIFont(name: "Quicksand-Regular", size: 16)
        locationLabel.font = UIFont(name: "Quicksand-Regular", size: 16)
        timesLabel.font = UIFont(name: "Quicksand-Regular", size: 16)
        contactLabel.font = UIFont(name: "Quicksand-Regular", size: 16)
        nameLabel.font = UIFont(name: "QuicksandDash-Regular", size: 35)
    }
    
    override func viewDidLoad() {
        var oppositeType = "pets"
        if userType == "pets" {
            oppositeType = "users"
        }
        var prof = retrieveUserProfile(username: userToDisplay, userType: oppositeType)
        interestsLabel.text = prof.interests
        timesLabel.text = prof.times
        nameLabel.text = prof.name
        image.image = prof.profileImage
        locationLabel.text = prof.location
        contactLabel.text = prof.phone
        
        super.viewDidLoad()
        loadData()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
