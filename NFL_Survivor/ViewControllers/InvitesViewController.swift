//
//  InvitesViewController.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 7/2/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import UIKit

class InvitesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    var invites = [Invite]()
    var invitesDictionary = [String : Any]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.fetchInvites()
        // Do any additional setup after loading the view.
    }
    func fetchInvites() {
        FirebaseAPIManager.fetchUserSpecificData("userInvites", "invites") { (dataDicsFound) in
            for inviteDic in dataDicsFound {
                self.invites.append(Invite(inviteDic))
            }
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath) as! InviteCell
        if invites.count != 0 {
            let owner = invites[indexPath.row].owner!
            let name = invites[indexPath.row].leagueName!
            cell.inviteDescriptionLabel.text = "\(owner) has invited you to join \(name)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accept = UIContextualAction(style: .normal, title: "Accept") { (action, view, nil) in
            FirebaseAPIManager.addUserToLeague(self.invites[indexPath.row].leagueID)
            FirebaseAPIManager.removeInvite(self.invites[indexPath.row].inviteID)
            self.invites.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            self.tableView.reloadData()
        }
        accept.backgroundColor = UIColor.green
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            FirebaseAPIManager.removeInvite(self.invites[indexPath.row].inviteID)
            self.invites.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            
            self.tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [delete, accept])
    }
}
