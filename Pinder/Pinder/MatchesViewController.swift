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
    var userToGoTo : String?
    var matches: [String] = []
    var matchesProfile : Dictionary<String,Profile> = [:]
    var profileImages : Dictionary<String, UIImage> = [:]
    

    
    @IBAction func browsePressed(_ sender: Any) {
        performSegue(withIdentifier: "toBrowseFromMatch", sender: nil)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSettingsFromMatch", sender: nil)
    }

    
    private func setupTableView() {
        self.table.dataSource = self
        self.table.delegate = self
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "match cell")
    }
    
    //make each cell propagate with proper image and title
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //change back after testing
        print("making cells .......")
        let cell = table.dequeueReusableCell(withIdentifier: "matchcell", for: indexPath) as! MatchTableViewCell
        //need to fix based on how this data will be fetched
        print("making cells 2.......")
        let temp = matches[indexPath.row]
        cell.matchName!.font = UIFont(name: "Quicksand-Bold", size: 30)
        cell.matchLocation.font = UIFont(name: "Quicksand-Italic", size: 20)
        
        cell.matchName!.text = matchesProfile[temp]?.name
        cell.matchImage?.image = profileImages[temp]
        cell.matchLocation.text = matchesProfile[temp]?.location
        
        return cell
    }
    
    //number of sections is the number of movies in favorites
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //for testing standard value change back for real deal
//        return matches.count
        return matchesProfile.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //send the current match/info
        
        //Set user and use retrieveUserProfile
        userToGoTo = matches[indexPath.row]
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
        setupTableView()
        
        // Do any additional setup after loading the view, typically from a nib.
        //Call getMatches to return usernames, and call retrieveUSerPorilfes on them!

        //matches = getMatches(username: curUser, userType: userType)
      
        print(matchesProfile)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ref = FIRDatabase.database().reference()
        ref.child("matches").child(userType).child(curUser).observeSingleEvent(of: .value, with:
            {(snapshot) in
                let enumerator = snapshot.children
                print("enter ==========")
                while let matche = enumerator.nextObject() as? FIRDataSnapshot{
                    if matche.value as! Int == 2 {
                        print("added")
                        self.matches.append(matche.key)
                        print(self.matches)
                    }
                }
                
                
                print(1)
                
                for match in self.matches {
                    var oppositeType = "pets"
                    if userType == "pets" {
                        oppositeType = "users"
                    }
                    print(2)
                    ref.child(oppositeType).child(match).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
                       
                        print(3)// Get user value
                        let dictionary = snapshot.value
                        print(dictionary ?? "")
                        print(3.5)
                        let dictionary2 = dictionary as! Dictionary<String,String>
                        let newProfile = Profile(dictionary: dictionary2)
                        print(newProfile)
                        self.matchesProfile[match] = newProfile;
                        
                    
                        
                        print("about to reload")
                        self.table.reloadData()
                    })
                    
                    
                    
                    ref.child(oppositeType).child(match).child("profileImage").observeSingleEvent(of: .value, with: { (snapshot) in
                        // check if user has photo
                        if let imageURL2  = snapshot.value {
                            // set image location
                            let imageURL = imageURL2 as? String
                            if imageURL != nil {
                                let imageLoadedURL = URL(string: imageURL as! String)
                                let data = try? Data(contentsOf: (imageLoadedURL)!)
                                let image = UIImage(data: data!)
                                self.profileImages[match] = image
                                
                            } else {
                                print("there are an empty profile image")
                            }
                        } else {
                            print("NOTHING HERE Url =wise)")
                        }
                        
                         self.table.reloadData()
                    })
                    
                    
                    
                    
                    
                    //self.table.reloadData()
                }

                
                
             self.table.reloadData()   // Update table here
        })
        
        
        
          //self.table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let detailViewController = segue.destination as? DetailViewController {
                detailViewController.userToDisplay = userToGoTo ?? ""
            }
        }
    }
    
    
    
}
