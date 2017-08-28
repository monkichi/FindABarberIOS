//
//  SignUpViewController.swift
//  FireBAseFindServicesApp
//
//  Created by Christian Zamudio on 8/5/17.
//  Copyright © 2017 Christian Zamudio. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    //userInfo for firebase user object
    var userName: String = " "
    var userEmailAddress: String = " "
    var userPassword: String = " "
    
    
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userEmailAddressTextField: UITextField!
    
    @IBAction func registerButtonTap(_ sender: Any) {
        
        print("Button was tapped")
        
        
        userName = userNameTextField.text!
        userEmailAddress = userEmailAddressTextField.text!
        userPassword = userPasswordTextField.text!
        
        Auth.auth().createUser(withEmail: userEmailAddress, password: userPassword) { (user, error) in
            // [START_EXCLUDE]
        
                if let error = error {
                    print(error.localizedDescription)
                }
                else{
                    print("\(user!.email!) created")
                    user?.sendEmailVerification(completion: { (error) in
                        if let error = error{
                            print(error.localizedDescription)
                        }
                        else{
                            print("Message sent")
                           
                        self.ref.child("users").child((user?.uid)!).setValue(["username": user?.email])
                        
                        self.ref.child("users").child((user?.uid)!).setValue(["userFullName": self.userNameTextField.text])
                        
                        
                        
                            
                            
                            
                        }
                        })
                    self.performSegue(withIdentifier: "register", sender: self)
                    }
  
            }
            // [END_EXCLUDE]
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        ref = Database.database().reference()
        
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
