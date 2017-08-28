//
//  MainLoginViewController.swift
//  FireBAseFindServicesApp
//
//  Created by Christian Zamudio on 8/5/17.
//  Copyright © 2017 Christian Zamudio. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainLoginViewController: UIViewController {

    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBAction func signInAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: userEmailTextField.text!, password: userPasswordTextField.text!) { (user, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else{
                print("\(user!.email!) login succesful")
                self.performSegue(withIdentifier: "signIn", sender: nil)

            }
        }
    }
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainLoginViewController.tapFunction))
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(tap)
 
    }
    
    
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        
       self.performSegue(withIdentifier: "signUp", sender: nil)
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
