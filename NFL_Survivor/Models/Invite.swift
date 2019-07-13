//
//  Invites.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 7/1/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import Foundation
class Invite {
    static let OWNER_KEY = "owner"
    static let LEAGUE_ID_KEY = "leagueID"
    static let LEAGUE_NAME_KEY = "leagueName"
    static let INVITE_ID_KEY = "inviteID"
    
    var owner: String!
    var leagueID : String!
    var leagueName : String!
    var inviteID : String!
    
    init(_ owner: String,_ leagueID : String, _ leagueName: String, _ inviteID: String ) {
        self.owner = owner
        self.leagueID = leagueID
        self.leagueName = leagueName
        self.inviteID = inviteID
    }
    init(_ inviteDictionary: [String : Any]) {
        self.inviteID = inviteDictionary[Invite.INVITE_ID_KEY] as? String
        self.leagueID = inviteDictionary[Invite.LEAGUE_ID_KEY] as? String
        self.leagueName = inviteDictionary[Invite.LEAGUE_NAME_KEY] as? String
        self.owner = inviteDictionary[Invite.OWNER_KEY] as? String
    }
    func getInviteAsSaveableJSON() -> [String : String] {
        var inviteDictionary = [String : String]()
        inviteDictionary[Invite.OWNER_KEY] = self.owner
        inviteDictionary[Invite.LEAGUE_NAME_KEY] = self.leagueName
        inviteDictionary[Invite.LEAGUE_ID_KEY] = self.leagueID
        inviteDictionary[Invite.INVITE_ID_KEY] = self.inviteID
        return inviteDictionary
    }
}
