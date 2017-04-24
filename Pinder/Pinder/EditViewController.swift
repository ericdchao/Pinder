//
//  EditViewController.swift
//  Pinder
//
//  Created by Kate Harline on 4/17/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

//access camera roll using https://turbofuture.com/cell-phones/Access-Photo-Camera-and-Library-in-Swift

import UIKit
import Firebase


class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var interestsField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var timesField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var editImageView: UIImageView!

    let storageRef = FIRStorage.storage().reference()
    //picking pictures
    
    var imagePicker = UIImagePickerController()
    
    @IBAction func pictureButton(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // image
            print("change!")
            editImageView.image = image
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        var dic : Dictionary<String, userProfileElement> = [:]
        
        dic["name"] = nameField.text!
        dic["age"] = ageField.text!
        dic["email"] = emailField.text!
        dic["password"] = passwordField.text!
        dic["interests"] = interestsField.text!
        dic["location"] = locationField.text!
        dic["times"] = timesField.text!
        dic["phone"] = phoneField.text!
        
        changeUserProfile(username: curUser, userType: userType, dictionary: dic)
        print("passed")
        if passwordField.text! != "" {
            changePassword(username: curUser,oldPassword: curPass, newPassword: passwordField.text!, userType: userType)
        }
        print("pass changed successfully")
        // if nameField.text != "" { dont do this, it doesn't work
        //    changeUserName(oldUsername: curUser, newUsername: nameField.text!, userType: userType)
        //}
        print("name changed")
        
        
        //Save Image
        var data = NSData()
        data = UIImageJPEGRepresentation(editImageView.image!, 1.0)! as NSData
        let imageRef = storageRef.child("images").child(curUser)
        
        let metaData = FIRStorageMetadata()
       
        metaData.contentType = "image/jpg"
        imageRef.put(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                //store downloadURL at database
                let ref = FIRDatabase.database().reference()
                ref.child(userType).child(curUser).child("profileImage").setValue(downloadURL)
                //self.databaseRef.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
            }
            
        }
        
        
        
        
        
        
        performSegue(withIdentifier: "editToSettings", sender: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "editToMatch", sender: nil)
    }
    
    override func viewDidLoad() {
        //var prof = retrieveUserProfile(username: curUser, userType: userType)
        let ref = FIRDatabase.database().reference()
        ref.child(userType).child(curUser).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            print("start")
            self.nameField.text = dictionary?["name"] as? String
            self.passwordField.text =  dictionary?["password"] as? String ?? ""
            self.interestsField.text =  dictionary?["interests"] as? String ?? ""
            self.ageField.text =  dictionary?["age"] as? String ?? ""
            self.timesField.text =  dictionary?["times"] as? String ?? ""
            self.phoneField.text =  dictionary?["phone"] as? String ?? ""
            self.locationField.text =  dictionary?["location"] as? String ?? ""
            
        })
        
        
        
        print("done")
        //imageField.image = prof.image
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        
        view.addGestureRecognizer(tap)
    
        ref.child(userType).child(curUser).child("profileImage").observeSingleEvent(of: .value, with: { (snapshot) in
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
                self.editImageView.image = image
                } else {
                    print("there are an empty profile image")
                }
            } else {
                print("NOTHING HERE Url =wise)")
            }
        })
        
     
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    
}
