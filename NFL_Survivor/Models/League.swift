//
//  League.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 6/30/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import Foundation
import Firebase

class League {
    
    static let nameDic = "name"
    static let ownerDic = "owner"
    static let membersDic = "members"
    //static let picksDic = "picks"
    static let currentWeekDic = "currentWeek"
    static let leagueIDDic = "leagueID"
    
    var name : String!
    var owner : String!
    var members : [String : Bool]!
    var picks : [String : [String : Any]]!
    var currentWeek : Int
    var leagueID : String!

    init(_ name: String, _ owner: String, _ leagueID: String) {
        self.name = name
        self.owner = owner
        self.members = [String : Bool]()
        self.picks = [String : [String : String]]()
        self.currentWeek = 0
        self.leagueID = leagueID
        self.addMember(self.owner)
        
    }
    init(_ dicitionary: [String : Any]) {
        self.name = dicitionary[League.nameDic] as? String
        self.owner = dicitionary[League.ownerDic] as? String
        let i = dicitionary[League.currentWeekDic] as? Int
        self.currentWeek = i!
        self.leagueID = dicitionary[League.leagueIDDic] as? String
        self.picks = [String : [String :Any]]()
        self.members = dicitionary[League.membersDic] as? [String : Bool]
        for i in 1...17 {
            let picks = dicitionary["\(i)"] as! [String : Any]
            self.picks["\(i)"] = picks
        }
    }
    func addMember(_ memberID: String) {
        self.members[memberID] = true
        let tempWeekPick = [memberID : Team.NIL.rawValue]
        for i in 1...17 {
            self.picks[("\(i)")] = tempWeekPick
        }
    }
    
    func getLeagueAsSaveableJSON() -> [String : Any] {
        var league = [String : Any]()
        league[League.nameDic] = self.name
        league[League.ownerDic] = self.owner
        league[League.membersDic] = self.members
        for i in 1...17 {
            let weekN = "\(i)"
            let pick = self.picks[weekN] as! [String : String]
            league[weekN] = pick
        }
        
        league[League.currentWeekDic] = self.currentWeek as NSNumber
        league[League.leagueIDDic] = self.leagueID
        return league
    }
    

    
    
    
}
