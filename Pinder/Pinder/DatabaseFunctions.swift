//
//  DatabaseFunctions.swift
//  Pinder
//
//  Created by Labuser on 4/7/17.
//  Copyright © 2017 Eric Chao. All rights reserved.
//

import Foundation
import Firebase

//https://www.firebase.com/docs/ios/guide/saving-data.html


//New User Functions

//Function to register a new user, just needs username and password
func saveNewUser(username: String, password: String) {
    let newUserRef = ref.child("users")
    newUserRef.child(username.lowercased())
    let newChildUserRef = newUserRef.child(username.lowercased())
    newChildUserRef.setValue(["username" : username,
                              "password": password])
}


//Function to register a new pet; just adds a username and a password
func saveNewPet(username: String, password: String){
    ref.child("pets").child(username).setValue(["username" : username,
                                                "password": password])
}

//Function to change a user or pet's profile with new values
//Does not return anything, but userType is either users or pets
func changeUserProfile(username : String, userType : String, dictionary: Dictionary<String, userProfileElement>){
    let userRef = ref.child(userType).child(username).child("profile")
    userRef.updateChildValues(dictionary)
}

//Function to attempt logging in with a username and password
//Returns isPet or isUser if successful, userPassDoesNotExist otherwise (These are constant enums)
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

//Function to retrieve Profiles of both pets and People
//Returns a Dictionary of each profile element
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

//Function to obtain un-swiped on matches for both users and pets
//Returns an array of usernames (of the opposite type), that can be passed into 'retriveUserProfile'
//Usertype is either users or pets
func getSwipes(username: String, userType:String) -> [String] {
    var unSwiped : [String] = []
    var oppositeType = "pets"
    if userType == "pets" {
        oppositeType = "users"
    }
    
    ref.child(oppositeType).observeSingleEvent(of: .value, with: {
        (snapshot) in
        let enumerator = snapshot.children
        while let user = enumerator.nextObject() as? FIRDataSnapshot{
            unSwiped.append(user.key)
        }
    })
    
    ref.child("matches").child(userType).child("/(username)").observeSingleEvent(of: .value, with: { (snapshot) in
        let enumerator = snapshot.children
        while let user = enumerator.nextObject() as? FIRDataSnapshot{
            unSwiped.remove(at: unSwiped.index(of: user.key )!) //very inefficient way to remove already matched things
        }
    })
    return unSwiped
}

//Function you call after swiping right on somebody to see if they matched you or not
// returns true if they already matched you, otherwise false
func tryMatch(username: String, userType: String, matchedUsername: String) -> Bool {
    var ans = false
    var defValue = 1
    var oppositeType = "pets"
    if userType == "pets" {
        oppositeType = "users"
    }
    
    //Check if other user matched
    ref.child("matches").child(oppositeType).child(matchedUsername).observeSingleEvent(of: .value, with: {(snapshot) in
        let enumerator = snapshot.children
        while let matches = enumerator.nextObject() as? FIRDataSnapshot{
            if matches.key == username { //It's a match!
                ans = true
                defValue = 2
                ref.child("matches").child(oppositeType).child(matchedUsername).child(username).setValue(2)
            }
        }
        
    })
    
    //Set own match value
    ref.child("matches").child(userType).child(username).child(matchedUsername).setValue(defValue)
    return ans
}

//function to obtain matches that already have been matched from both ends!
//returns an array of usernames (of the opposite type)
func getMatches(username: String, userType: String) ->  [String] {
    var ans : [String] = []
    ref.child("matches").child(userType).child(username).observeSingleEvent(of: .value, with:
    {(snapshot) in
      let enumerator = snapshot.children
        while let matches = enumerator.nextObject() as? FIRDataSnapshot{
            if matches.value as! Int == 2 {
                ans.append(matches.value as! String)
            }
        }
    })
    return ans
}

//Function to change the username of a user or a pet
func changeUserName(oldUsername: String, newUsername: String, userType: String){
    ref.child(userType).child("/(oldUsername)").setValue(newUsername.lowercased())
}


