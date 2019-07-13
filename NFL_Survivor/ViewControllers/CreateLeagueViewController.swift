//
//  CreateLeagueViewController.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 6/24/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import UIKit
import Firebase
class CreateLeagueViewController: UIViewController {
    var ref : DatabaseReference!
    
    @IBOutlet weak var leagueNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapCreate(_ sender: Any) {
        if self.leagueNameTextField.text!.count > 5{
            self.ref = Database.database().reference()
            
            let testId = self.ref.child("leagues").childByAutoId().key!
            let league = League(self.leagueNameTextField.text!, Auth.auth().currentUser!.displayName!, testId)
            self.ref.child("leagues").child(testId).setValue(league.getLeagueAsSaveableJSON())
            self.ref.child("userLeagues").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                var dic = [NSString : Bool]()
                if value != nil {
                    dic = value as! [NSString : Bool]
                }
                dic[testId as NSString] = true
                self.ref.child("userLeagues").child(Auth.auth().currentUser!.uid).setValue(dic)
            }
            currentLeague = league
            self.performSegue(withIdentifier: "createToOwnerPage", sender: nil)
        }
    }
}

