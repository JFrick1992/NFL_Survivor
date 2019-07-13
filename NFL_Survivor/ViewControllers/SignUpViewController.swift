//
//  SignUpViewController.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 6/22/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        if self.isInuputValid() {
            let email = self.emailTextField.text!
            let password = self.passwordTextField.text!
            let username = self.usernameTextField.text!
            
            FirebaseAPIManager.signUpUser(email: email , password: password, username: username) { (errorCode) in
                if errorCode == FirebaseAPIManager.NO_ERROR {
                    print("No Error")
                    self.performSegue(withIdentifier: "signUpToHub", sender: nil)
                } else if errorCode == FirebaseAPIManager.DATABASE_ERROR {
                    print("ERROR: Problem connecting to database")
                } else if errorCode == FirebaseAPIManager.USERNAME_EXISTS {
                    print("ERROR: Username exists")
                }
            }
        }
    }


    func isInuputValid() -> Bool {
        //later add stuff to notify about incorrect fields
        if self.emailTextField.text!.count == 0 {
            return false
        }
        if self.passwordTextField.text!.count < 6 {
            return false
        }
        if self.usernameTextField.text!.count < 6 {
            return false
        }
        return true
    }
}
