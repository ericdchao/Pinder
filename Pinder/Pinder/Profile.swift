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
    
    var name : String?
    var profileImage: UIImage?
    var password : String?
    var interests: String?
    var location : String?
    var phone : String?
    var times : String?
    var age : String?
    
    
    
    init (dictionary : Dictionary<String, userProfileElement>) {
        if let name2 = dictionary["name"] {
            name = name2 as? String
        } else {
            name = ""
        }
        
        if let interests3 = dictionary["interests"] {
             interests = interests3 as? String
        } else {
            interests = ""
        }
        if let location2 = dictionary["location"] {
            location = location2 as! String
        } else {
            location = ""
        }
        if let password2 = dictionary["password"] {
            password = password2 as! String
        } else {
            password = ""
        }
        if let phone2 = dictionary["phone"] {
            phone = phone2 as! String
        } else {
            phone = ""
        }
        if let times2 = dictionary["times"] {
            times = times2 as! String
        } else {
            times = ""
        }
        if let age2 = dictionary["times"] {
            age = age2 as! String
        } else {
            age = ""
        }
        
        
    }
    
}
