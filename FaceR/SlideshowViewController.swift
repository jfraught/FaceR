//
//  SlideshowViewController.swift
//  FaceR
//
//  Created by Jordan Fraughton on 7/17/17.
//  Copyright © 2017 Jordan Fraughton. All rights reserved.
//

import UIKit

class SlideshowViewController: UIViewController {
    
    // MARK: - Actions 

    func action() {
        time += 1
        print("timer is at \(time)")
    }
    
    @IBAction func swipedLeft(_ sender: UISwipeGestureRecognizer) {
        if time >= minimumTime {
            print("Swiped left")
            if imageIndex == album.fullAlbum.count - 1 {
                return
            } else if imageIndex < album.fullAlbum.count {
                imageIndex += 1
                print(imageIndex)
                updateViews(index: imageIndex)
                time = 0
            }
        } else {
            return
        }
        
    }
    
    @IBAction func swipedRight(_ sender: UISwipeGestureRecognizer) {
        print("Swiped right")
        if time >= minimumTime {
            if imageIndex == 0 {
                print(imageIndex)
                return
            } else if imageIndex > 0 {
                print(imageIndex)
                imageIndex -= 1
                updateViews(index: imageIndex)
                time = 0
            }
        } else {
            return
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageIndex = 0
        updateViews(index: imageIndex)
        self.SlideshowImageView?.isUserInteractionEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SlideshowViewController.action), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    private func updateViews(index: Int) {
        album.fetchFullAlbumWith(index: album.index)
        SlideshowImageView.image = album.fullAlbum[index]
        navigationItem.title = "Slide \(index + 1) of \(album.fullAlbum.count)"
    }
    
    @IBOutlet weak var SlideshowImageView: UIImageView!

    // MARK: - Properties
    
    let minimumTime = Settings.shared.timerCount
    var imageIndex: Int = 0
    let album = Album.shared
    var time = 0
    var timer = Timer()
    
}
