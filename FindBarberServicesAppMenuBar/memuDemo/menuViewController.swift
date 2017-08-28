//
//  menuViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth


class menuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    
    override func viewWillAppear(_ animated: Bool) {
        downLoadProfileImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Names of Menu Settings
        ManuNameArray = ["My Account","Payment Options","Balance","Transaction History", "Settings", "Help", "Info"]
        
        //Array for Menu Images
        iconArray = [UIImage(named:"home")!,UIImage(named:"message")!,UIImage(named:"map")!,UIImage(named:"setting")!,UIImage(named:"setting")!,UIImage(named:"setting")!,UIImage(named:"setting")!]
        
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.borderColor = UIColor.green.cgColor
        imgProfile.layer.cornerRadius = 50
        
        imgProfile.layer.masksToBounds = false
        imgProfile.clipsToBounds = true 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManuNameArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.lblMenuname.text! = ManuNameArray[indexPath.row]
        cell.imgIcon.image = iconArray[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let cell:MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        print(cell.lblMenuname.text!)
        if cell.lblMenuname.text! == "My Account"
        {
            print("My Account tapped")
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController

            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            self.revealViewController().pushFrontViewController(newFrontController, animated: true)
            
            
        }
        if cell.lblMenuname.text! == "Message"
        {
            print("message Tapped")
           
          
        }
        if cell.lblMenuname.text! == "Map"
        {
            print("Map Tapped")
        }
        if cell.lblMenuname.text! == "Setting"
        {
           print("setting Tapped")
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
                self.imgProfile.image = image
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
