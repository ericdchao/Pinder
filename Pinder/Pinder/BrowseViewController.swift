//
//  MatchesViewController.swift
//  Pinder
//
//  Created by Kate Harline on 4/10/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

import UIKit
import Firebase
import CDAlertView

class BrowseViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    
    @IBAction func noButton(_ sender: Any) {
        //animate and update db when not interested
    }
    @IBAction func yesButton(_ sender: Any) {
        //animate and update db when interested
    }
    
    
    
    @IBAction func matchPressed(_ sender: Any) {
        performSegue(withIdentifier: "toMatches", sender: nil)
    }
    @IBAction func settingPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: nil)
    }
    
    func petLoaded() {
        //pull from database, set image and name
    }
    
    func updataImage(){
        // first get the user images 
        // self.imageView.image = UIImage(nextImage)
    }
    
    let matchAlert = CDAlertView(title: "It's a Match !", message: "Well explained message!", type: .notification)
    let doneAction = CDAlertViewAction(title: " Contact her💪")
    let nevermindAction = CDAlertViewAction(title: "Keep Swiping 😑")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        petImage.isUserInteractionEnabled = true
        
        petImage.addGestureRecognizer(gesture)
        matchAlert.add(action: nevermindAction)
        matchAlert.add(action: doneAction)
        
        nameLabel.font = UIFont(name: "QuicksandDash-Regular", size: 35)

    }
    

    
    
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        label.transform = stretchAndRotation
        
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            if label.center.x < 100 {
                
                print("Not chosen")
                updataImage()
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
//                
//                let label = UILabel(frame: CGRect(x: self.view.bounds.width / 2 - 100, y: self.view.bounds.height / 2 - 50, width: 200, height: 100))
//                
//                label.text = "Drag me!"
//                
//                label.textAlignment = NSTextAlignment.center
                matchAlert.show()
//                var contentView:UIView
//                
//                convenience init(contentView: UIView)
//                
//                view.addSubview(label)

                
                print("Chosen")
                updataImage()
                
            }
            
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
            
            
            label.transform = stretchAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
