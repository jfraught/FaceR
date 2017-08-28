//
//  EndOfSlideshowViewController.swift
//  FaceR
//
//  Created by Jordan Fraughton on 8/22/17.
//  Copyright © 2017 Jordan Fraughton. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class EndOfSlideshowViewController: UIViewController {

    // MARK: - Actions
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        PhotoManager().saveVideoToUserLibrary(fileUrl: self.fileLocation!) { (success, error) in
            if success {
                print("File saved to photos")
            } else {
                print("File not saved to photos")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Properties 
    
    var fileLocation: URL?
    
}
