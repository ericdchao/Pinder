//
//  ViewController.swift
//  Pinder
//
//  Created by Kate Harline on 4/3/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

//font help from http://codewithchris.com/common-mistakes-with-adding-custom-fonts-to-your-ios-app/
//dismiss keyboard with tap http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift

import UIKit
import Firebase

var curUser = ""
var curPass = ""
var userType = ""
//let ref = FIRDatabaseReference!.self
let storage = FIRStorage.storage()
let storageRef = storage.reference()
class ViewController: UIViewController {

   
  
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBAction func registerClicked(_ sender: Any) {
       curUser = usernameField.text!
        curPass =  passwordField.text!
        self.performSegue(withIdentifier: "registerSeg", sender: nil)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
       // curUser = username
        print("1 ========")
        var userField = usernameField.text ?? "blank"
        var passField = passwordField.text ?? "blank"
        curPass = passField;
        curUser = userField;
        GlobalUser.init(curUser: userField, curPass: passField)

        loginUsersUser(with: userField, password: passField, completion: { success in
            if success {
                userType = "users"
                loginUsersPass(with: userField, password: passField, completion: { success in
                    if success {
                      self.performSegue(withIdentifier: "login", sender: nil)
                    }
                })
            } else {
               // print ("no you aint no user")
            }
        })
        
        loginPetsUser(with: userField, password: passField, completion: { success in
            if success {
                //print("Yay is a pet username good")
                userType = "pets"
                loginPetsPass(with: userField, password: passField, completion: { success in
                    if success {
                        //print("You're a pet, Larry!")
                        self.performSegue(withIdentifier: "login", sender: nil)
                    }
                })
            } else {
               // print ("no you aint no pet")
            }
        })
     
   
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        
        //might need to check font names

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class Register1VC: ViewController {
    @IBAction func humanReg(_ sender: Any) {
        saveNewPet(username: curUser, password: curPass)
        userType = "pets"
        performSegue(withIdentifier: "regToEdit", sender: "human")
    }
    @IBAction func petReg(_ sender: Any) {
        saveNewUser(username: curUser, password: curPass)
        userType = "users"
        performSegue(withIdentifier: "regToEdit", sender: "pet")
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

struct GlobalUser {
    var curUser : String
    var curPass : String
    
}
