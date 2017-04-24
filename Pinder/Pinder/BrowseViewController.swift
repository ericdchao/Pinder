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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    
    @IBAction func noButton(_ sender: Any) {
        //animate and update db when not interested
    }
    @IBAction func yesButton(_ sender: Any) {
        //animate and update db when interested
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
        if usersArray.isEmpty {
            //Print error message no more users
            nameLabel.text = "Looking for more users ..."
        } else {
            let topUser = usersArray[0]
            nameLabel.text = topUser
//            petImage.image = swipesArray[topUser]?.profileImage
            
            
        }
        
        
        // self.petImage.image = UIImage(nextImage)
    }
    
    func someHandler(alert: CDAlertViewAction!) {
        // Do something...
        print("Handle!")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("=======Dylan's choice=======")
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        petImage.isUserInteractionEnabled = true
        
        petImage.addGestureRecognizer(gesture)
        
        nameLabel.font = UIFont(name: "QuicksandDash-Regular", size: 30)
        
        var oppositeType = "pets"
        if userType == "pets" {
            oppositeType = "users"
        }
        
        usersArray = getSwipes(username: curUser, userType: userType)
        
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

        ref.child("matches").child(userType).child(curUser).observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            print("3 =======removing=======")
            while let user = enumerator.nextObject() as? FIRDataSnapshot{
                print(user.key)
                self.usersArray.remove(at: self.usersArray.index(of: user.key )!) //very inefficient way to remove already matched things
            }
            
        print("4 =======done removing=======")
        
        print("5 ======= swipe array=======")
        
            for user in self.usersArray {
                self.ref.child(oppositeType).child(user).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
                    // Get user value
                    let dictionary = snapshot.value
                    
                    let newProfile = Profile(dictionary: dictionary as! Dictionary<String, String>)
                    
                    self.swipesArray[user] = newProfile
                    print(user)
                    print("6 =======get user=======")
                })
                
            }
// loop end
            self.updateImage()
        })


        
        
    }
    


    
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let matchAlert = CDAlertView(title: "It's a Match !", message: "", type: .notification)
        let doneAction = CDAlertViewAction(title: " Contact her💪")
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
                matchAlert.show()

                
                print("Not chosen")
                if usersArray.count > 0 { // What is this check?
                    usersArray.remove(at: 0)
                }
                updateImage()
            } else if label.center.x > self.view.bounds.width - 100 {
                print("Chosen")
                var oppositeType = "pets"
                if userType == "pets" {
                    oppositeType = "users"
                }
                
                //Check if other user matched
                ref.child("matches").child(oppositeType).child(usersArray[0]).observeSingleEvent(of: .value, with: {(snapshot) in
                    let enumerator = snapshot.children
                       print(self.usersArray[0])
                    while let matches = enumerator.nextObject() as? FIRDataSnapshot{
                        if matches.key == curUser { //It's a match!
                            print("=======match!=======")
                            self.ref.child("matches").child(oppositeType).child(self.usersArray[0]).child(curUser).setValue(2)
                            self.ref.child("matches").child(userType).child(curUser).child(self.usersArray[0]).setValue(2) //set own value
                            matchAlert.show()
                        } else {
                            print("=======not match!=======")
                            self.ref.child("matches").child(userType).child(curUser).child(self.usersArray[0]).setValue(1)
                        }
                    }
                    self.usersArray.remove(at: 0)
                    self.updateImage()

                })
                

                
            }
            
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
            
            
            label.transform = stretchAndRotation
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
