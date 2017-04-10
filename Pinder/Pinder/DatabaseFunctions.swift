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

func changeUserProfile(username : String, dictionary: Dictionary<String, String>){
    let userRef = ref.child("users").child(username)
    userRef.updateChildValues(dictionary)
    
}
