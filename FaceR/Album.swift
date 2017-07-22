//
//  Album.swift
//  FaceR
//
//  Created by Jordan Fraughton on 6/15/17.
//  Copyright © 2017 Jordan Fraughton. All rights reserved.
//

import Foundation
import Photos

class Album {

    init() {
        let fetchedUserCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: PHFetchOptions())
        
        self.userCollections = fetchedUserCollections
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
    }
    
    // MARK: - Actions
  
    func fetchFirstImage() {

        // Loop through user collections and take the first image of each collection and append it to the array.
        
        if userCollections.count > 0 {
            
            for i in 0..<userCollections.count {
                
                let album = userCollections.object(at: i)
                
                guard let firstImageAsset = PHAsset.fetchAssets(in: album, options: PHFetchOptions()).firstObject else { return }
                
                guard let albumName = album.localizedTitle else { return }
                albumNameArrary.append(albumName)
                
                imgManager.requestImage(for: firstImageAsset, targetSize: CGSize.init(width: 175, height: 175), contentMode: .default, options: requestOptions, resultHandler:
                    {
                        image, error in
                        
                        if let firstImage = image {
                            self.firstImageArray.append(firstImage)
                        }
                })
                
            }
        }
    }
    
    func fetchFullAlbumWith(index: Int) {
        
        // Fetch required album and convert to [UIImage]
        
        let album = userCollections.object(at: index)
        
        let albumAssets = PHAsset.fetchAssets(in: album, options: PHFetchOptions())
        
        self.fullAlbum = []
        
        for i in 0..<albumAssets.count {
            
            imgManager.requestImage(for: albumAssets[i], targetSize: .init(width: 1000, height: 1000), contentMode: .default, options: requestOptions, resultHandler:
                {
                    image, error in
                    
                    if let newImage = image {
                        self.fullAlbum.append(newImage)
                    }
                })
        }
        print(fullAlbum.count)
    }
    
    // MARK: - Properties
    var index = 0 
    let requestOptions = PHImageRequestOptions()
    static let shared = Album()
    let userCollections: PHFetchResult<PHAssetCollection>
    var firstImageArray: [UIImage] = []
    var albumNameArrary: [String] = []
    var fullAlbum: [UIImage] = []
    let imgManager = PHImageManager.default()
    let fetchOptions = PHFetchOptions()
    
}
