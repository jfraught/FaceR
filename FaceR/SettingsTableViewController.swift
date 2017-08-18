//
//  SettingsTableViewController.swift
//  FaceR
//
//  Created by Jordan Fraughton on 8/17/17.
//  Copyright © 2017 Jordan Fraughton. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Actions
    
    @IBAction func stepperWasTouched(_ sender: UIStepper) {
        stepCount = Int(sender.value)
        stepperCountLabel.text = String(stepCount)
        Settings.shared.timerCount = stepCount
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        secondsStepper.value = Double(Settings.shared.timerCount)
        stepperCountLabel.text = "\(Settings.shared.timerCount)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    // MARK: - Properties
    @IBOutlet weak var secondsStepper: UIStepper!
    @IBOutlet weak var stepperCountLabel: UILabel!
    var stepCount: Int = 0
    
    

}
