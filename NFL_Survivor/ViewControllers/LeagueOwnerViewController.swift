//
//  LeagueOwnerViewController.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 7/1/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import UIKit

class LeagueOwnerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var moveStartWeekButton: UIButton!
    @IBOutlet weak var inviteOwnerPickButton: UIBarButtonItem!
    @IBOutlet weak var currentWeekLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var members = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentWeekLabel.text = "Current Week: \(currentLeague.currentWeek)"
        self.title = currentLeague.name
        self.tableView.delegate = self
        self.tableView.dataSource = self
        for key in currentLeague.members.keys {
            members.append(key)
        }
        if currentLeague.currentWeek > 0 {
            self.inviteOwnerPickButton.title = "My Picks"
        
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapMoveStartWeekButton(_ sender: Any) {
        
        if currentLeague.currentWeek > 0 {
            self.updateUsersAliveStatus()
        }
        currentLeague.currentWeek+=1
        self.currentWeekLabel.text = "Current Week: \(currentLeague.currentWeek)"
        FirebaseAPIManager.updateCurrentWeekOfCurrentLeague()
    }
    
    func updateUsersAliveStatus() {
        FirebaseAPIManager.getAllMembersPicksForWeekN(currentLeague.currentWeek) { (usersNPIcks) in
            for key in usersNPIcks.keys {
                let pick = usersNPIcks[key] as! String
                let team = Team.init(rawValue: pick)!
                if !Schedule.didTeamWin(team, currentLeague.currentWeek) {
                    currentLeague.members[key] = false
                    FirebaseAPIManager.eliminateMemberInLeague(key)
                }
            }
            self.members = [String]()
            for key in currentLeague.members.keys {
                self.members.append(key)
            }
            self.tableView.reloadData()
        }
        
    }
    @IBAction func didTapInviteOwnerPickButton(_ sender: Any) {
        if currentLeague.currentWeek == 0 {
            performSegue(withIdentifier: "ownerToInvite", sender: nil)
        } else {
            performSegue(withIdentifier: "ownerToPicker", sender: nil)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
        let member = self.members[indexPath.row]
        var status = String()
        if currentLeague.members[member] == true {
            status = "Alive"
        } else {
            status = "Dead"
        }
        let descript = "Name: \(member)\nStatus: \(status)"
        cell.memberDescription.text = descript
        
        return cell
    }
}
