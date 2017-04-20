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
    
    //picking pictures
    @IBAction func pictureButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //save picked picture to database
        //save image storageRef.upload(image)
        
        self.dismiss(animated: true, completion: nil);
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
        if passwordField.text! != "" {
            changePassword(username: curUser,oldPassword: curPass, newPassword: passwordField.text!, userType: userType)
        }
        
        if nameField.text != "" {
            changeUserName(oldUsername: curUser, newUsername: nameField.text!, userType: userType)
        }
        performSegue(withIdentifier: "editToSettings", sender: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "editToMatch", sender: nil)
    }
    
    override func viewDidLoad() {
        var prof = retrieveUserProfile(username: curUser, userType: userType)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
