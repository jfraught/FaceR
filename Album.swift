//
//  Album.swift
//  FaceR
//
//  Created by Jordan Fraughton on 5/17/17.
//  Copyright © 2017 Jordan Fraughton. All rights reserved.
//

import Foundation
import Photos

class Album {
    // TODO: Fetch smart albums
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    
    init() {
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
    }
    // TODO: add a variable for the first photo in a smart album and name of album 
    
    // TODO: take out the recently deleted
}
