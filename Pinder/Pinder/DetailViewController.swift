//
//  DetailViewController.swift
//  Pinder
//
//  Created by Kate Harline on 4/10/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class DetailViewController: UIViewController,  MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    var userToDisplay : String = ""
    
    @IBAction func contactButton(_ sender: Any) {
        sendMessage()
    }
    @IBAction func locationButton(_ sender: Any) {
        print("location clicked")
        let location = locationLabel.text!.replacingOccurrences(of: " ", with: ",", options: .literal, range: nil)
        if let url = URL(string: "http://maps.apple.com/?address=\(location)") {
            print("location worked")
            UIApplication.shared.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly : true], completionHandler: nil)
        } else {
            return
        }
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "detailToMatches", sender: nil)
    }
    
    @IBAction func settingPress(_ sender: Any) {
        performSegue(withIdentifier: "detailToSettings", sender: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message send cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message send failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message send succes")
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func sendMessage() {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "Hey! Can we meet up some time"
        messageVC.recipients = [contactLabel.text!]
        messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: false, completion: nil)
    }
    
    func matchLoaded() {
        interestsLabel.font = UIFont(name: "Quicksand-Regular", size: 16)
        locationLabel.font = UIFont(name: "Quicksand-Regular", size: 16)
        timesLabel.font = UIFont(name: "Quicksand-Regular", size: 16)
        contactLabel.font = UIFont(name: "Quicksand-Regular", size: 16)
        nameLabel.font = UIFont(name: "Quicksand-Bold", size: 35)
    }
    
    override func viewDidLoad() {
        var oppositeType = "pets"
        if userType == "pets" {
            oppositeType = "users"
        }
        
        var ref = FIRDatabase.database().reference()
        ref.child(oppositeType).child(userToDisplay).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
            // Get user value
            
            let dictionary = snapshot.value as? NSDictionary
            self.interestsLabel.text = dictionary?["interests"] as? String ?? ""
            self.timesLabel.text = dictionary?["times"] as? String ?? ""
            self.nameLabel.text = dictionary?["name"] as? String ?? ""
            // image.image = prof.profileImage
            self.locationLabel.text = dictionary?["location"] as? String ?? ""
            self.contactLabel.text = dictionary?["phone"] as? String ?? ""
            
        })

        
        ref.child(oppositeType).child(userToDisplay).child("profileImage").observeSingleEvent(of: .value, with: { (snapshot) in
            // check if user has photo
            if let imageURL2  = snapshot.value {
                // set image location
                let imageURL = imageURL2 as? String
                if imageURL != nil {
                    let imageLoadedURL = URL(string: imageURL as! String)
                    let data = try? Data(contentsOf: (imageLoadedURL)!)
                    let image = UIImage(data: data!)
                    self.image.image = image
                } else {
                    print("there are an empty profile image")
                }
            } else {
                print("NOTHING HERE Url =wise)")
            }
        })
        
        matchLoaded()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
