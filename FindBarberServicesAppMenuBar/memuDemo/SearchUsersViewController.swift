//
//  SearchUsersViewController.swift
//  memuDemo
//
//  Created by Christian Zamudio on 8/8/17.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference!
    var refHandle : UInt!
    var userModelArray = [searchUserModel]()
    
    
    @IBOutlet weak var usersListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        ref = Database.database().reference()
        
        refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            
            //Get the users in the data base
            
        })
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModelArray.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "sign"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as? SearchUsersTableViewCell  else {
            fatalError("The dequeued cell is not an instance of Search User Cell.")
        }
        
        cell.userNameUILabel.text = userModelArray[indexPath.row].userName
        cell.userServiceProviderUILabel.text = userModelArray[indexPath.row].userServiceProviderType
        
        cell.userUIImageView.image = userModelArray[indexPath.row].userImage
        cell.usersRatingIndicatorUIImageView.image = userModelArray[indexPath.row].userRatingImage
        
        return cell
        
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        
        
    }



}
