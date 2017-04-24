//
//  MatchesViewController.swift
//  Pinder
//
//  Created by Kate Harline on 4/10/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

import UIKit
import Firebase
import CDAlertView

class BrowseViewController: UIViewController {
    var ref = FIRDatabase.database().reference()
    var usersArray : [String] = []
    var swipesArray : Dictionary<String, Profile> = [:]
    var profileImages : Dictionary<String, UIImage> = [:]
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var petImage: UIImageView?
    
    
    //note directions are reversed bc Kate doesn't know how real tinder works
    @IBAction func noButton(_ sender: Any) {
        let matchAlert = CDAlertView(title: "It's a Match !", message: "", type: .success)
        let doneAction = CDAlertViewAction(title: " Contact them 💪", handler: { doneAction in self.performSegue(withIdentifier: "browseToDetail", sender: nil)})
        let nevermindAction = CDAlertViewAction(title: "Keep Swiping 😑")
        matchAlert.add(action: nevermindAction)
        matchAlert.add(action: doneAction)
        
        //animate and update db when interested
        if(usersArray.count != 0){
            
            
            
            var oppositeType = "pets"
            if userType == "pets" {
                oppositeType = "users"
            }
            
            //Check if other user matched
            ref.child("matches").child(oppositeType).child(usersArray[0]).observeSingleEvent(of: .value, with: {(snapshot) in
                let enumerator = snapshot.children
                print(self.usersArray[0])
                self.ref.child("matches").child(userType).child(curUser).child(self.usersArray[0]).setValue(1)
                while let matches = enumerator.nextObject() as? FIRDataSnapshot{
                    if matches.key == curUser { //It's a match!
                        print("=======match!=======")
                        self.ref.child("matches").child(oppositeType).child(self.usersArray[0]).child(curUser).setValue(2)
                        self.ref.child("matches").child(userType).child(curUser).child(self.usersArray[0]).setValue(2) //set own value
                        self.userToGoTo = self.usersArray[0]
                        matchAlert.show()
                    }
                }
                if self.usersArray.count > 0 {
                    self.usersArray.remove(at: 0)
                }
                self.updateImage()
                
                
            })
            
        }
        
    }
    @IBAction func yesButton(_ sender: Any) {
        //animate and update db when not interested
        if usersArray.count > 0 { // What is this check?
            usersArray.remove(at: 0)
            
        }
        updateImage()
    }
    
    
    
    @IBAction func matchPressed(_ sender: Any) {
        performSegue(withIdentifier: "toMatches", sender: nil)
    }
    @IBAction func settingPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: nil)
    }
    
    func petLoaded() {
        //pull from database, set image and name
    }
    
    func updateImage(){
        // first get the user images 
        print("======= update image =======")
        if usersArray.isEmpty || usersArray.count == 0 {
            //Print error message no more users
            nameLabel?.text = "No more :("
            self.petImage?.removeFromSuperview()
        } else {
            let topUser = usersArray[0]
            let namee = swipesArray[topUser]?.name ?? "Name Error"
            if let ageTemp = swipesArray[topUser]?.age {
                nameLabel?.text = "\(namee), \(ageTemp)"
            } else {
                nameLabel?.text = "\(namee)"
            }
            
//            petImage.image = swipesArray[topUser]?.profileImage
            
            
            self.petImage?.image = self.profileImages[usersArray[0]]
            print("Upload successfull")
        }
        
        
    }
    

    
    var userToGoTo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("=======Dylan's choice=======")
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        petImage?.isUserInteractionEnabled = true
        
        petImage?.addGestureRecognizer(gesture)
        
        nameLabel?.font = UIFont(name: "Quicksand-Bold", size: 30)
        
        var oppositeType = "pets"
        if userType == "pets" {
            oppositeType = "users"
        }
        
        
        ref.child(oppositeType).observeSingleEvent(of: .value, with: {
            (snapshot) in
            let enumerator = snapshot.children
              print("1 ======= appending=======")
            while let user = enumerator.nextObject() as? FIRDataSnapshot{
              
                print(user.key)
                self.usersArray.append(user.key)
            }
            print("2 ======= done appending=======")
        })

        print(userType)
        print(curUser)
        print("300030300333")
        ref.child("matches").child(userType).child(curUser).observeSingleEvent(of: .value, with: { (snapshot) in
            print("error444444")
            let enumerator = snapshot.children
            print("3 =======removing=======")
            while let user = enumerator.nextObject() as? FIRDataSnapshot{
                print(user.key)
                if(user.key != "test"){
                    print("RIGHT BEFORE")
                self.usersArray.remove(at: self.usersArray.index(of: user.key )!)
                }
                //very inefficient way to remove already matched things
            }
            
        print("4 =======done removing=======")
        
        print("5 ======= swipe array=======")
        
            for user in self.usersArray {
                self.ref.child(oppositeType).child(user).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
                    // Get user value
                    print("testttt")
                    let dictionary = snapshot.value
                    
                    let newProfile = Profile(dictionary: dictionary as! Dictionary<String, String>)
                    
                    self.swipesArray[user] = newProfile
                    print(user)
                    print("6 =======get user=======")
                })
                
                self.ref.child(oppositeType).child(user).child("profileImage").observeSingleEvent(of: .value, with: { (snapshot) in
                    print("1231231231")
                    // check if user has photo
                    if let imageURL2  = snapshot.value {
                        // set image location
                        let imageURL = imageURL2 as? String
                        if imageURL != nil {
                            print("YOU GOTTA CHILD WOOHO")
                            let imageLoadedURL = URL(string: imageURL!)
                            let data = try? Data(contentsOf: (imageLoadedURL)!)
                            let image = UIImage(data: data!)
                            self.profileImages[user] = image
                        } else {
                            print("there are an empty profile image")
                        }
                    } else {
                        print("NOTHING HERE Url =wise)")
                    }
                    
                    
                      self.updateImage()
                })
                
                
                
                
            }
// loop end
           
            print("eric's check")
        })
        print("Kate's Check")
        if(self.usersArray.count == 0) {
            self.nameLabel?.text = "No more :("
        }
        
        
        
    }
    


    
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let matchAlert = CDAlertView(title: "It's a Match !", message: "", type: .success)
        let doneAction = CDAlertViewAction(title: " Contact her💪", handler: { doneAction in self.performSegue(withIdentifier: "browseToDetail", sender: nil)})
        let nevermindAction = CDAlertViewAction(title: "Keep Swiping 😑")
        matchAlert.add(action: nevermindAction)
        matchAlert.add(action: doneAction)
        
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        label.transform = stretchAndRotation
        
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
             print(usersArray)
             print(swipesArray)
         
            if label.center.x < 100 {
                print("Not chosen")
                if usersArray.count > 0 { // What is this check?
                    usersArray.remove(at: 0)
                    
                }
                updateImage()
                
            } else if label.center.x > self.view.bounds.width - 100 {
                print("Chosen")
                if(usersArray.count != 0){
                    
                
                
                var oppositeType = "pets"
                if userType == "pets" {
                    oppositeType = "users"
                }
                
                //Check if other user matched
                ref.child("matches").child(oppositeType).child(usersArray[0]).observeSingleEvent(of: .value, with: {(snapshot) in
                    let enumerator = snapshot.children
                       print(self.usersArray[0])
                     self.ref.child("matches").child(userType).child(curUser).child(self.usersArray[0]).setValue(1)
                    while let matches = enumerator.nextObject() as? FIRDataSnapshot{
                        if matches.key == curUser { //It's a match!
                            print("=======match!=======")
                            self.ref.child("matches").child(oppositeType).child(self.usersArray[0]).child(curUser).setValue(2)
                            self.ref.child("matches").child(userType).child(curUser).child(self.usersArray[0]).setValue(2) //set own value
                            self.userToGoTo = self.usersArray[0]
                            matchAlert.show()
                        } 
                    }
                    if self.usersArray.count > 0 {
                        self.usersArray.remove(at: 0)
                    }
                    self.updateImage()
                    

                })
                
                }
                
            }
            
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
            
            
            label.transform = stretchAndRotation
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "browseToDetail" {
            if let detailViewController = segue.destination as? DetailViewController {
                detailViewController.userToDisplay = userToGoTo
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
