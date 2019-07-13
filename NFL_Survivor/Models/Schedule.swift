//
//  Schedule.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 6/22/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import Foundation
import  UIKit


class Schedule {
    var games = [[Game]]()
    init() {
        self.games = [[Game]]()
    }
    init(_ gameDictionaryArray: [[String: Any]]) {
        for _ in 0...16 {
            let test = [Game]()
            games.append(test)
        }
        for gameDictionary in gameDictionaryArray {
            let game = Game(gameDictionary)
            games[game.week-1].append(game)
        }
    }
    func printSchedule() {
        for week in games {
            for game in week {
                print(game.print())
            }
        }
    }
    static func didTeamWin(_ team: Team, _ weekN: Int) -> Bool{
        let week = NFLSchedule.games[weekN-1]
        for game in week {
            if team == game.winner() {
                return true
            }
        }
        return false
    }
}
