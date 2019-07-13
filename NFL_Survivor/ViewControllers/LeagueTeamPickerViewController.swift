//
//  LeagueTeamPickerViewController.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 6/29/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import UIKit

class LeagueTeamPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GameCellDelegate {


    
    @IBOutlet weak var tableView: UITableView!
    var currentTeamSelected : Team!
    var picks = [Team]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.title = "Week: \(currentLeague.currentWeek)"
        // Do any additional setup after loading the view.
        self.getPicks()
    }
    
    func getPicks() {
        FirebaseAPIManager.fetchUserPicks { (picks) in
            self.picks = picks
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        if currentLeague.currentWeek == 0 {
            return 0
        } else {
            return NFLSchedule.games[currentLeague.currentWeek].count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell
        let game = NFLSchedule.games[currentLeague.currentWeek-1][indexPath.row]
        cell.awayTeam = game.awayTeam
        cell.homeTeam = game.homeTeam
        
        cell.awayTeamLabel.text = game.awayTeam.rawValue
        cell.homeTeamLabel.text = game.homeTeam.rawValue
         let awayImage = UIImage(imageLiteralResourceName: "\(game.awayTeam.rawValue)")
        let homeImage = UIImage(imageLiteralResourceName: "\(game.homeTeam.rawValue)")
        cell.awayTeamLogo.image = awayImage
        cell.homeTeamLogo.image = homeImage
        cell.delegate = self
        if picks.count > 0 {
            if wasTeamAlreadyChosen(game.awayTeam) && picks[currentLeague.currentWeek-1] != game.awayTeam {
                cell.awayTeamButton.isEnabled = false
                cell.awayTeamButton.isHidden = true
            } else if picks[currentLeague.currentWeek-1] == game.awayTeam {
                cell.awayTeamButton.setImage(#imageLiteral(resourceName: "Radio Button Fill.png"), for: .normal)
                cell.awayTeamButton.isHidden = false
                cell.awayTeamButton.isEnabled = true
            } else {
                cell.awayTeamButton.setImage(#imageLiteral(resourceName: "Radio Button.png"), for: .normal)
                cell.awayTeamButton.isHidden = false
                cell.awayTeamButton.isEnabled = true
            }
        
            if wasTeamAlreadyChosen(game.homeTeam) && picks[currentLeague.currentWeek-1] != game.homeTeam {
                cell.homeTeamButton.isEnabled = false
                cell.homeTeamButton.isHidden = true
            } else if picks[currentLeague.currentWeek-1] == game.homeTeam {
                cell.homeTeamButton.setImage(#imageLiteral(resourceName: "Radio Button Fill.png"), for: .normal)
                cell.homeTeamButton.isHidden = false
                cell.homeTeamButton.isEnabled = true
            } else {
                cell.homeTeamButton.setImage(#imageLiteral(resourceName: "Radio Button.png"), for: .normal)
                cell.homeTeamButton.isHidden = false
                cell.homeTeamButton.isEnabled = true
            }
        }
        
        return cell
    }

    func updateRadioButtons(_ teamSelected: Team) {
        self.picks[currentLeague.currentWeek-1] = teamSelected
        self.tableView.reloadData()
    }
    func wasTeamAlreadyChosen(_ teamSelected: Team) -> Bool {
        for team in picks {
            if team == teamSelected {
                return true
            }
        }
        return false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    @IBAction func didTapSaveButton(_ sender: Any) {
        if self.picks[currentLeague.currentWeek-1] != Team.NIL {
            FirebaseAPIManager.saveMyPick(self.picks[currentLeague.currentWeek-1])
        }
    }
    
}
