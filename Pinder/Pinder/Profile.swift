//
//  Profile.swift
//  Pinder
//
//  Created by Labuser on 4/17/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

import Foundation
import UIKit


class Profile {
    
    var name : String
    var profileImage: UIImage
    var password : String
    var interests: String
    var location : String
    var phone : String
    var times : String
    var age : String
    
    
    
    init (dictionary : Dictionary<String, userProfileElement>) {
        name = dictionary["name"] as! String
        age = dictionary["age"] as! String
        profileImage = dictionary["profileImage"] as! UIImage
        interests = dictionary["interests"] as! String
        password = dictionary["password"] as! String
        location = dictionary["location"] as! String
        phone = dictionary["phone"] as! String
        times = dictionary["times"] as! String
        
        
    }
    
}
