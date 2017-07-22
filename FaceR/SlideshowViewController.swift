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
    
    @IBAction func swipedLeft(_ sender: UISwipeGestureRecognizer) {
        print("Swiped left")
        if imageIndex == album.fullAlbum.count - 1 {
            return
        } else if imageIndex < album.fullAlbum.count {
            imageIndex += 1
            print(imageIndex)
            updateViews(index: imageIndex)
        }
        
    }
    @IBAction func swipedRight(_ sender: UISwipeGestureRecognizer) {
        print("Swiped right")
        if imageIndex == 0 {
            print(imageIndex)
            return
        } else if imageIndex > 0 {
            print(imageIndex)
            imageIndex -= 1
            updateViews(index: imageIndex)
        }
        
    }
    
    let album = Album.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        imageIndex = 0
        updateViews(index: imageIndex)
        self.SlideshowImageView?.isUserInteractionEnabled = true 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false 
    }
   
    private func updateViews(index: Int) {
        album.fetchFullAlbumWith(index: album.index)
        SlideshowImageView.image = album.fullAlbum[index]
    }
    
    @IBOutlet weak var SlideshowImageView: UIImageView!

    // MARK: - Properties 
    var imageIndex: Int = 0
}
