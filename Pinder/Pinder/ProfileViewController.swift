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
        let storageRef = storage.reference()
        
        interestsLabel.font = UIFont(name: "Quicksand-Regular", size: 16)
        locationLabel.font = UIFont(name: "Quicksand-Regular", size: 16)
        timesLabel.font = UIFont(name: "Quicksand-Regular", size: 16)
        contactLabel.font = UIFont(name: "Quicksand-Regular", size: 16)
        nameLabel.font = UIFont(name: "Quicksand-Bold", size: 35)
    }
    
    override func viewDidLoad() {
        var oppositeType = "pets"
        if userType == "pets" {
            oppositeType = "users"
        }
    
        var ref = FIRDatabase.database().reference()
        ref.child(userType).child(curUser).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
            // Get user value
          
             let dictionary = snapshot.value as? NSDictionary
                print("start")
                self.interestsLabel.text = dictionary?["interests"] as? String ?? ""
                self.timesLabel.text = dictionary?["times"] as? String ?? ""
                self.nameLabel.text = dictionary?["name"] as? String ?? ""
                // image.image = prof.profileImage
                self.locationLabel.text = dictionary?["location"] as? String ?? ""
                self.contactLabel.text = dictionary?["phone"] as? String ?? ""
            
        })

        
        ref.child(userType).child(curUser).child("profileImage").observeSingleEvent(of: .value, with: { (snapshot) in

            // check if user has photo
            if let imageURL2  = snapshot.value {
                // set image location
                let imageURL = imageURL2 as? String
                if imageURL != nil {
                    let imageLoadedURL = URL(string: imageURL as! String)
                    let data = try? Data(contentsOf: (imageLoadedURL)!)
                    let image = UIImage(data: data!)
                    self.image.image = image
                } else {
                    print("there are an empty profile image")
                }
            } else {
                print("NOTHING HERE Url =wise)")
            }
        })
        
        super.viewDidLoad()
        loadData()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         var ref = FIRDatabase.database().reference()
        ref.child(userType).child(curUser).child("profileImage").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // check if user has photo
            if let imageURL2  = snapshot.value {
                // set image location
                let imageURL = imageURL2 as? String
                if imageURL != nil {
                    let imageLoadedURL = URL(string: imageURL as! String)
                    let data = try? Data(contentsOf: (imageLoadedURL)!)
                    let image = UIImage(data: data!)
                    self.image.image = image
                } else {
                    print("there are an empty profile image")
                }
            } else {
                print("NOTHING HERE Url =wise)")
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
