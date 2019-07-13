//
//  FirebaseAPIManager.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 7/1/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import Foundation
import Firebase

var currentLeague : League!
class FirebaseAPIManager {
    static let NO_ERROR = 0
    static let DATABASE_ERROR = 1
    static let USERNAME_EXISTS = 2
    static let USERNAME_NOT_FOUND = 404
    static let NO_INVITES_FOUND = 3
    
    
    static func signUpUser(email: String, password: String, username: String, completion: @escaping(Int)->()) {
        //Completion function to find if user exits, upon completion, signup happens if
        //username does not exist
        FirebaseAPIManager.findUser(username) { (usernameDic, error) in
            //if the user name is not in database, then sign up user
            if error == FirebaseAPIManager.USERNAME_NOT_FOUND {
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if error == nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.commitChanges(completion: { (erorr) in
                            if error == nil {
                                FirebaseAPIManager.addUserToUserNode(Auth.auth().currentUser!.uid)
                                completion(FirebaseAPIManager.NO_ERROR)
                            }
                        })
                    //if error in sign up
                    } else if error != nil {
                        completion(FirebaseAPIManager.DATABASE_ERROR)
                    }
                }
            //returns if username exists, signup is canceled
            } else if error == FirebaseAPIManager.USERNAME_EXISTS {
                completion(FirebaseAPIManager.USERNAME_EXISTS)
            //if some error happens with finding user
            } else {
                completion(FirebaseAPIManager.DATABASE_ERROR)
            }
        }
    }
    
    static func findUser(_ username: String, completion: @escaping(NSDictionary?, Int)->()) {
        let ref = Database.database().reference().child("users")
        ref.child(username).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value == nil {
                completion(nil,FirebaseAPIManager.USERNAME_NOT_FOUND)
            } else {
                completion(value, FirebaseAPIManager.USERNAME_EXISTS)
            }
        }
    }
    static func addUserToUserNode(_ userID: String) {
        let ref = Database.database().reference().child("users")
        let userInfo = ["userID" : Auth.auth().currentUser!.uid]
        ref.child(Auth.auth().currentUser!.displayName!).setValue(userInfo)
    }
    static func sendUserInvite(_ userID: String) {

        let ref = Database.database().reference()
        let inviteKey = ref.childByAutoId().key!
        let invite = Invite(currentLeague.owner as String, currentLeague.leagueID as String, currentLeague.name as String, inviteKey)
        ref.child("invites").child(inviteKey).setValue(invite.getInviteAsSaveableJSON())
        ref.child("userInvites").child(userID).observeSingleEvent(of: .value){
            (snapshot) in
            let value = snapshot.value as? NSDictionary
            var dic = [NSString : Bool]()
            if value != nil {
                dic = value as! [NSString : Bool]
            }
            dic[inviteKey as NSString] = false
            ref.child("userInvites").child(userID).setValue(dic)
        }
    }
    static func fetchUserSpecificData(_ firstChild: String, _ secondChild: String, completion: @escaping([[String : Any]])->()) {
        let ref = Database.database().reference()
        var hasCompleted = false
        ref.child(firstChild).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            if value != nil {
                let dic = value as! [String : Any]
                var dataDicsFound = [[String : Any]]()
                let dispatchGroup = DispatchGroup()
                for key in dic.keys {
                    dispatchGroup.enter()
                    Database.database().reference().child(secondChild).child(key).observeSingleEvent(of: .value, with:
                        { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        if value != nil {
                            let dic = value as! [String: Any]
                            dataDicsFound.append(dic)
                        }
                        dispatchGroup.leave()
                    })
                    dispatchGroup.notify(queue: .main, execute: {
                        if dataDicsFound.count == dic.keys.count && !hasCompleted {
                            hasCompleted = true
                            completion(dataDicsFound)
                        }
                    })
                }
            } else {
                completion([[String : Any]]())
            }
        }
    }

    static func removeInvite(_ inviteId: String) {
        let ref = Database.database().reference()
        ref.child("userInvites").child(Auth.auth().currentUser!.uid).child(inviteId).removeValue()
        ref.child("invites").child(inviteId).removeValue()
    }
    
    static func fetchUserPicks(completion: @escaping([Team])->()) {
        let ref = Database.database().reference().child("leagues").child(currentLeague.leagueID)
        var hasCompleted = false
        var picks = [Team]()
        let dispatchGroup = DispatchGroup()
        for i in 1...17 {
            let n = "\(i)" as String
            dispatchGroup.enter()
            ref.child(n).child(Auth.auth().currentUser!.displayName!).observeSingleEvent(of: .value)
            { (snapshot) in
                if snapshot.value != nil {
                    let teamPicked = snapshot.value as! String
                    let team = Team.init(rawValue: teamPicked)
                    picks.append(team!)
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            if picks.count == 17 && !hasCompleted {
                hasCompleted = true
                completion(picks)
            }
        }
    }
    static func createLeague(_ leagueName: String, completion: @escaping(Int)->()) {
        let ref = Database.database().reference()
        let leagueID = ref.child("leagues").childByAutoId().key!
        let league = League(leagueName, Auth.auth().currentUser!.displayName!, leagueID)
        ref.child("leagues").child(leagueID).setValue(league.getLeagueAsSaveableJSON())
        FirebaseAPIManager.addLeagueToUser(leagueID)
        currentLeague = league
        completion(FirebaseAPIManager.NO_ERROR)
        
    }
    static func addLeagueToUser(_ leagueID: String) {
        let ref = Database.database().reference()
        ref.child("userLeagues").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) {
            (snapshot) in
                let value = snapshot.value as? NSDictionary
                var dic = [String : Bool]()
                if value != nil {
                    dic = value as! [String : Bool]
                }
                dic[leagueID] = true
                ref.child("userLeagues").child(Auth.auth().currentUser!.uid).setValue(dic)
            }
            
    }
    static func addUserToLeague(_ leagueID: String) {
        let ref = Database.database().reference()
        FirebaseAPIManager.addLeagueToUser(leagueID)
        for i in 1...17 {
            let weekN = "\(i)"
            ref.child("leagues").child(leagueID).child(weekN).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as! NSDictionary
                var dic = value as! [String : Any]
                dic[Auth.auth().currentUser!.displayName!] = Team.NIL.rawValue
                ref.child("leagues").child(leagueID).child(weekN).setValue(dic)
            }
        }
        ref.child("leagues").child(leagueID).child("members").observeSingleEvent(of: .value)
        { (snapshot) in
            let value = snapshot.value as! NSDictionary
            var dic = value as! [String : Any]
            dic[Auth.auth().currentUser!.displayName!] = true
            ref.child("leagues").child(leagueID).child("members").setValue(dic)
        }
        
    }
    static func updateCurrentWeekOfCurrentLeague() {
        let ref = Database.database().reference()
    ref.child("leagues").child(currentLeague.leagueID).child("currentWeek").setValue(currentLeague.currentWeek as NSNumber)
    }
    static func saveMyPick(_ team: Team) {
        let ref = Database.database().reference().child("leagues").child(currentLeague.leagueID)
        let weekN = "\(currentLeague.currentWeek)"
        ref.child(weekN).child(Auth.auth().currentUser!.displayName!).setValue(team.rawValue)
    }
    static func getAllMembersPicksForWeekN(_ n: Int, completion: @escaping([String : Any])->()) {
        let ref = Database.database().reference().child("leagues").child(currentLeague.leagueID)
        let weekN = "\(n)" as String
        ref.child(weekN).observeSingleEvent(of: .value) { (snapshot) in
            let dic = snapshot.value as! NSDictionary?
            if dic != nil {
                completion(dic as! [String : Any])
            }
        }
    }
    
    static func eliminateMemberInLeague(_ username: String) {
        let ref = Database.database().reference().child("leagues").child(currentLeague.leagueID)
        ref.child("members").child(username).setValue(false)
    }
}


