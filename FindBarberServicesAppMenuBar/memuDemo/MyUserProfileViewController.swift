//
//  MyUserProfileViewController.swift
//  memuDemo
//
//  Created by Christian Zamudio on 8/23/17.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class MyUserProfileViewController: UIViewController {

    @IBOutlet weak var myUserProfileImageView: UIImageView!
    
    @IBOutlet weak var myUserProfileNameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        downLoadProfileImage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                  self.myUserProfileImageView.image = image
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
