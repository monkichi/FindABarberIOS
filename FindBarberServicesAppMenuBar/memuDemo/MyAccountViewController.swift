//
//  MyAccountViewController.swift
//  memuDemo
//
//  Created by Christian Zamudio on 8/12/17.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class MyAccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    @IBOutlet weak var myAccountSettingsTableView: UITableView!
    @IBOutlet weak var myAccountImageView: UIImageView!
    @IBOutlet weak var editLabel: UILabel!
    
    
    var myAccountSettingsStrings : [String] = ["View Profile", "Services"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add sibebar
        // Do any additional setup after loading the view, typically from a nib.
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            btnMenuButton.target = revealViewController()
            btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainLoginViewController.tapFunction))
        editLabel.isUserInteractionEnabled = true
        editLabel.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        downLoadProfileImage()
        
        self.myAccountSettingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "userSettingsCell")
        myAccountSettingsTableView.delegate = self
        myAccountSettingsTableView.dataSource = self
        
   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        downLoadProfileImage()
    }
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        
        self.performSegue(withIdentifier: "editAccountSegue", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAccountSettingsStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.myAccountSettingsTableView.dequeueReusableCell(withIdentifier: "userSettingsCell")!
        
        cell.textLabel?.text = myAccountSettingsStrings[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionSelected = myAccountSettingsStrings[indexPath.row]
        
        if optionSelected == "View Profile"
        {
            print("View Profile Tapped")
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
           
            let destination = storyboard.instantiateViewController(withIdentifier: "myUserProfileViewController") as! MyUserProfileViewController
            
            navigationController?.pushViewController(destination, animated: true)
        }
        

        if optionSelected == "Services"{
            print("Services Tapped")
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            let destination = storyboard.instantiateViewController(withIdentifier: "viewServicesViewController") as! ViewServicesViewController
            
            navigationController?.pushViewController(destination, animated: true)
        }
        
    }
    
    
    func downLoadProfileImage(){
        // Create a reference to the file we want to download
        let starsRef = Storage.storage().reference().child("\(Auth.auth().currentUser!.uid)/\("userPhoto")")
        
        // Start the download (in this case writing to a file)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        let downloadTask = starsRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
                print(error?.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                self.myAccountImageView.image = image
                print("Got the image")
            }
        }
        // Observe changes in status
        downloadTask.observe(.resume) { snapshot in
            // Download resumed, also fires when the download starts
        }
        
        downloadTask.observe(.pause) { snapshot in
            // Download paused
        }
        
        downloadTask.observe(.progress) { snapshot in
            // Download reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
        }
        
        downloadTask.observe(.success) { snapshot in
            // Download completed successfully
            
        }
        
        // Errors only occur in the "Failure" case
        downloadTask.observe(.failure) { snapshot in
            guard let errorCode = (snapshot.error as? NSError)?.code else {
                return
            }
            guard let error = StorageErrorCode(rawValue: errorCode) else {
                return
            }
            switch (error) {
            case .objectNotFound:
                // File doesn't exist
                break
            case .unauthorized:
                // User doesn't have permission to access file
                break
            case .cancelled:
                // User cancelled the download
                break
                
                /* ... */
                
            case .unknown:
                // Unknown error occurred, inspect the server response
                break
            default:
                // Another error occurred. This is a good place to retry the download.
                break
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
