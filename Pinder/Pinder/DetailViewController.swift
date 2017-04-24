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
    
    @IBAction func contactButton(_ sender: Any) {
        sendMessage()
    }
    @IBAction func locationButton(_ sender: Any) {
        let location = locationLabel.text!.replacingOccurrences(of: " ", with: ",", options: .literal, range: nil)
        if let url = URL(string: "http://maps.apple.com/?address=\(location)") {
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
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
