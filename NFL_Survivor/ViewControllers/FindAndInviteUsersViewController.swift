//
//  FindAndInviteUsersViewController.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 7/1/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import UIKit

class FindAndInviteUsersViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapFind(_ sender: Any) {
        let username = self.usernameTextField.text!
        if username.count > 5 {
            FirebaseAPIManager.findUser(username) { (userNSDic, code) in
                if code == FirebaseAPIManager.USERNAME_EXISTS && userNSDic != nil {
                    print("User: \(username) found")
                    let userDic = userNSDic as! [String : Any]
                    let userFoundsID = userDic["userID"] as! String
                    print("Users ID: \(userFoundsID)")
                    FirebaseAPIManager.sendUserInvite(userFoundsID)
                    
                } else if code == FirebaseAPIManager.USERNAME_NOT_FOUND {
                    print("User: \(username) does not exist")
                }
            }
        }
    }
    


}
