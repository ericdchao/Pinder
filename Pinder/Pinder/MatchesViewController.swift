//
//  MatchesViewControlle.swift
//  Pinder
//
//  Created by Kate Harline on 4/10/17.
//  Copyright © 2017 Kate Harline. All rights reserved.
//

//code for custom tableview cells https://www.ralfebert.de/tutorials/ios-swift-uitableviewcontroller/custom-cells/

import UIKit
import Firebase

//make custom class for custom cell styling
class MatchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var matchImage: UIImageView!
    @IBOutlet weak var matchName: UILabel!
    @IBOutlet weak var matchLocation: UILabel!
}

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    var matches: [userProfileElement] = []
    

    
    @IBAction func browsePressed(_ sender: Any) {
        performSegue(withIdentifier: "toBrowseFromMatch", sender: nil)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSettingFromMatch", sender: nil)
    }

    
    private func setupTableView() {
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "match cell")
    }
    
    //make each cell propagate with proper image and title
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //change back after testing
        let cell = table.dequeueReusableCell(withIdentifier: "match cell", for: indexPath) as! MatchTableViewCell
        //need to fix based on how this data will be fetched
        cell.matchName!.text = "match name"
        cell.matchImage?.image = #imageLiteral(resourceName: "profile")
        cell.matchLocation.text = "changed location label"
        
        return cell
    }
    
    //number of sections is the number of movies in favorites
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //for testing standard value change back for real deal
//        return matches.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //send the current match/info
        
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    //delete rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            //remove match from matches db and refresh the list
        }
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
