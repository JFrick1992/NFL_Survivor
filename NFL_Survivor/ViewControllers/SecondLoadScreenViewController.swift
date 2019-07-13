//
//  SecondLoadScreenViewController.swift
//  NFL_Survivor
//
//  Created by Jacob Frick on 6/22/19.
//  Copyright © 2019 Jacob Frick. All rights reserved.
//

import UIKit

class SecondLoadScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NFLAPIManager.grabFullNFLSeason { (schedule, error) in
            if let schedule = schedule {
                NFLSchedule = schedule
                //schedule.printSchedule()
                self.performSegue(withIdentifier: "secondLoadToLogin", sender: nil)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
    }
   
    


}
