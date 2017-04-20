//
//  MatchesViewControlle.swift
//  Pinder
//
//  Created by Kate Harline on 4/10/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

//code for custom tableview cells https://www.ralfebert.de/tutorials/ios-swift-uitableviewcontroller/custom-cells/

import UIKit
import Firebase

//make custom class for custom cell styling
class MatchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var matchImage: UIImageView!
    @IBOutlet weak var matchName: UILabel!
    @IBOutlet weak var matchLocation: UILabel!
}

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    var matches: [String] = []
    var matchesProfile : Dictionary<String,Profile> = [:]
    

    
    @IBAction func browsePressed(_ sender: Any) {
        performSegue(withIdentifier: "toBrowseFromMatch", sender: nil)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSettingsFromMatch", sender: nil)
    }

    
    private func setupTableView() {
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "match cell")
    }
    
    //make each cell propagate with proper image and title
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //change back after testing
        let cell = table.dequeueReusableCell(withIdentifier: "match cell", for: indexPath) as! MatchTableViewCell
        //need to fix based on how this data will be fetched
        cell.matchName!.text = "match name"
        cell.matchImage?.image = #imageLiteral(resourceName: "profile")
        cell.matchLocation.text = "changed location label"
        
        return cell
    }
    
    //number of sections is the number of movies in favorites
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //for testing standard value change back for real deal
//        return matches.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //send the current match/info
        
        //Set user and use retrieveUserProfile
        
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    //delete rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            //remove match from matches db and refresh the list
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Call getMatches to return usernames, and call retrieveUSerPorilfes on them!

        //matches = getMatches(username: curUser, userType: userType)
        
        let ref = FIRDatabase.database().reference()
        ref.child("matches").child(userType).child(curUser).observeSingleEvent(of: .value, with:
            {(snapshot) in
                let enumerator = snapshot.children
                while let matche = enumerator.nextObject() as? FIRDataSnapshot{
                    if matche.value as! Int == 2 {
                        self.matches.append(matche.key as! String)
                    }
                }
        })
     
        
        
        for match in matches {
            var oppositeType = "pets"
            if userType == "pets" {
                oppositeType = "users"
            }
            
            ref.child(oppositeType).child(match).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
                // Get user value
                let dictionary = snapshot.value as? NSDictionary
                let newProfile = Profile(dictionary: dictionary as! Dictionary<String, userProfileElement>)
                  self.matchesProfile[match] = newProfile
            })

            
          
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
