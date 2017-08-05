//
//  MainLoginViewController.swift
//  FireBAseFindServicesApp
//
//  Created by Christian Zamudio on 8/5/17.
//  Copyright © 2017 Christian Zamudio. All rights reserved.
//

import UIKit

class MainLoginViewController: UIViewController {

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
        
        performSegue(withIdentifier: "signUp", sender: nil)
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
