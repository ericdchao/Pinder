//
//  DatabaseFunctions.swift
//  Pinder
//
//  Created by Labuser on 4/7/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

import Foundation
import Firebase


//New User Functions
func saveNewUser(username: String, password: String) {
    let newUserRef = ref.child("users")
    newUserRef.child(username.lowercased())
    let newChildUserRef = newUserRef.child(username.lowercased())
    newChildUserRef.setValue(["username" : username,
                              "password": password])
}

func changeUserName(oldUsername: String, newUsername: String){
    ref.child("users").child("/(oldUsername)").setValue(newUsername.lowercased())
}

func saveNewPet(username: String, password: String){
    ref.child("pets").child(username).setValue(["username" : username,
                                                "password": password])
    
}

//https://www.firebase.com/docs/ios/guide/saving-data.html

func changeUserProfile(username : String, userType : String, dictionary: Dictionary<String, userProfileElement>){
    let userRef = ref.child(userType).child(username).child("profile")
    userRef.updateChildValues(dictionary)
}

func login(username: String, password: String) -> Int {
    let newRef = ref.child("users");
    var ans = userPassDoesNotExist;
    newRef.observeSingleEvent(of: .value, with: { snapshot in
        // do some stuff once
        if(!snapshot.exists()){
            ans =  -1; //Error!!! Somebody messed up our database schema for users
        } else if(snapshot.hasChild("/(username)")){
            if(newRef.child("/username").value(forKey: "password") as! String == password){
                ans = isUser;
            }
        }
        
    });
    ref.child("pets").observeSingleEvent(of: .value, with: {snapshot in
        if(snapshot.hasChild("/(username)")){
            if(ref.child("pets").child("/(username)").value(forKey: "password") as! String == password){
                ans = isPet;
            }
        }
});

    return ans;
}

//userType = users if people, pets if not
func retrieveUserProfile(username: String, userType : String) -> Dictionary<String,userProfileElement>{
    var dictionary = Dictionary<String,userProfileElement>()

    ref.child(userType).child("/(username)").child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
        dictionary = (snapshot.value as? Dictionary<String,userProfileElement>)!
    }) { (error) in
        print(error.localizedDescription)
    }
    return dictionary
}

protocol userProfileElement {}
extension String : userProfileElement {}
extension UIImage : userProfileElement {}
extension Double : userProfileElement {}
