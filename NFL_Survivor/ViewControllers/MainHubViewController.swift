//
//  MainHubViewController.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 6/22/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class MainHubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    var isMenuOpen = Bool()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftMainSubViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightMainSubViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuBarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuBarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenu: UIView!
    
    @IBOutlet weak var mainSubView: UIView!
    
    var leagues = [League]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isMenuOpen = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchLeagues()

    }
    func fetchLeagues() {
        FirebaseAPIManager.fetchUserSpecificData("userLeagues", "leagues") { (dataDicsFound) in
            for dic in dataDicsFound {
                self.leagues.append(League(dic))
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func didTapMenuButton(_ sender: Any) {
        if self.isMenuOpen {
            self.leftMainSubViewConstraint.constant = 0
            self.rightMainSubViewConstraint.constant = 0
            self.menuBarLeadingConstraint.constant = -self.sideMenu.bounds.width
        } else {
            self.leftMainSubViewConstraint.constant = self.sideMenu.bounds.width
            self.rightMainSubViewConstraint.constant = self.sideMenu.bounds.width
            self.menuBarLeadingConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
        self.isMenuOpen = !self.isMenuOpen
    }
    @IBAction func didTapProfileButton(_ sender: Any) {
    }
    @IBAction func didTapInvitesButton(_ sender: Any) {
        self.performSegue(withIdentifier: "hubToInvites", sender: nil)
    }
    @IBAction func didTapCreateButton(_ sender: Any) {
        self.performSegue(withIdentifier: "hubToCreateLeague", sender: nil)
    }
    @IBAction func didTapSignOutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "logInViewController")
            self.present(vc, animated: false, completion: nil)
            
        }
    }
    @IBAction func didTapRulesButton(_ sender: Any) {
        self.isMenuOpen = false
        self.performSegue(withIdentifier: "hubToRules", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueCell
        if leagues.count > 0 {
            let owner = self.leagues[indexPath.row].owner!
            let name = self.leagues[indexPath.row].name!
            cell.leagueDescriptionLabel.text = "\(name)\nOwner: \(owner)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentLeague = self.leagues[indexPath.row]
        if self.leagues[indexPath.row].owner == Auth.auth().currentUser!.displayName! {
            self.performSegue(withIdentifier: "hubToOwner", sender: nil)
        }  else {
            if currentLeague.members[Auth.auth().currentUser!.displayName!] == false {
                self.performSegue(withIdentifier: "toUserLostScreen", sender: nil)
            } else if didUserWin() {
                self.performSegue(withIdentifier: "toUserWonScreen", sender: nil)
            } else {
                self.performSegue(withIdentifier: "hubToMemberPicker", sender: nil)
            }
        }
    }
    func didUserWin() -> Bool {
        if currentLeague.members[Auth.auth().currentUser!.displayName!] == false {
            return false
        }
        for key in currentLeague.members.keys {
            if key != Auth.auth().currentUser!.displayName! {
                if currentLeague.members[key] == true {
                    return false
                }
            }
        }
        return true
    }

}

