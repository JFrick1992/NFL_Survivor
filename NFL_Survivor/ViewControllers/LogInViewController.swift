//
//  LogInViewController.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 6/22/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapLogIin(_ sender: Any) {
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        if email.count > 0 && password.count > 0 {
            Auth.auth().signIn(withEmail: email, password: password) { (results, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "logInToHub", sender: nil)
                }
            }
        }
    }
    

}
