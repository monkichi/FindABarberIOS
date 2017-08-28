//
//  EditAccountViewController.swift
//  memuDemo
//
//  Created by Christian Zamudio on 8/12/17.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase


class EditAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userProfileVariableArray: [String] = []
    var userProfileImageView: UIImageView!
    @IBOutlet weak var userProfileImageButton: UIButton!
    
    // Create a storage reference from our storage service
    var storageRef = Storage.storage().reference()
    var databaseRef : DatabaseReference!
   
    
    


    @IBAction func changeImage(_ sender: Any) {
        
        let alert = UIAlertController(title: "AlertController Tutorial",
                                      message: "Upload or Take Photo",
                                      preferredStyle: .alert)
        
        // Take button
        let takePhotoAction = UIAlertAction(title: "Take", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            print("take pressed")
           //Check if camer is available
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                //instantiate imagepickercontroller
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                print("Camera is available")
            }
            else{
                print("Camera not available")
            }

        })
        
        // Upload button
        let uploadPhotoAction = UIAlertAction(title: "Upload", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            print("Upload pressed")
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        
        // Add action buttons and present the Alert
        alert.addAction(takePhotoAction)
        alert.addAction(uploadPhotoAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var editInformationFillInTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
                self.editInformationFillInTableView.register(UITableViewCell.self, forCellReuseIdentifier: "userInfoCell")
        
        // Get a reference to the storage service using the default Firebase App
        databaseRef = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        //Prefill some of the users information
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            
            print("Got the users email " + email!)
            userProfileVariableArray.append(email!)
        }
        
        //Get Users Info
        databaseRef.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let userName = value?["userFullName"] as? String ?? ""
            print(userName)
            self.userProfileVariableArray.append(userName)
            self.editInformationFillInTableView.reloadData()
            //self.editInformationFillInTableView.endUpdates()
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Create a reference to the file we want to download
        let starsRef = storageRef.child("\(Auth.auth().currentUser!.uid)/\("userPhoto")")
        
        // Start the download (in this case writing to a file)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
       let downloadTask = starsRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
                print(error?.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                self.userProfileImageButton.setImage(image, for: .normal)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(self.userProfileVariableArray.count)
        return self.userProfileVariableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create the cell
        let cell:UITableViewCell = editInformationFillInTableView.dequeueReusableCell(withIdentifier: "userInfoCell")!
        
        cell.textLabel?.text = self.userProfileVariableArray[indexPath.row]
        cell.detailTextLabel?.text = self.userProfileVariableArray[indexPath.row]
        
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ffdaskfjdksf
        
        let alertController = UIAlertController(title: "Edit " + userProfileVariableArray[indexPath.row], message: "Please input your " + userProfileVariableArray[indexPath.row] + ": ", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                // store your data
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = self.userProfileVariableArray[indexPath.row]
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        userProfileImageButton.setImage(image, for: .normal)
        
        dismiss(animated:true, completion: nil)
        var data = NSData()
        data = UIImageJPEGRepresentation(image, 0.8)! as NSData
        // set upload path
        let filePath = "\(Auth.auth().currentUser!.uid)/\("userPhoto")"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        self.storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print("Could not upload image" + error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                //store downloadURL at database
                self.databaseRef.child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
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
