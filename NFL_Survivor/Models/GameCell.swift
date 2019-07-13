//
//  GameCell.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 7/3/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import UIKit
protocol GameCellDelegate : class {
    func updateRadioButtons(_ teamSelected : Team)
}
class GameCell: UITableViewCell {
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamButton: UIButton!
    @IBOutlet weak var homeTeamButton: UIButton!
    var homeTeam : Team!
    var awayTeam : Team!
    weak var delegate : GameCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func didTapAwayTeamButton(_ sender: Any) {
        delegate?.updateRadioButtons(self.awayTeam)
    }
    @IBAction func didTapHomeTeamButton(_ sender: Any) {
        delegate?.updateRadioButtons(self.homeTeam)
    }
    
}
