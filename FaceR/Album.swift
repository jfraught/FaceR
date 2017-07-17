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
    }
    
    // MARK: - Actions
    
   
        
        
       
        
    
    
    func fetchFirstImage() {

        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        // Loop through user collections and take the first image of each collection and append it to the array.
        
        if userCollections.count > 0 {
            
            for i in 0..<userCollections.count {
                
                let album = userCollections.object(at: i)
                
                guard let firstImageAsset = PHAsset.fetchAssets(in: album, options: PHFetchOptions()).lastObject else { return }
                
                guard let albumName = album.localizedTitle else { return }
                albumNameArrary.append(albumName)
                
                // firstImage: UIImage
                
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
    
    func fetchFullAlbum() {
        
        // Fetch required album
        
    }
    
    
    
    
    // MARK: - Properties
    
    static let shared = Album()
    
    let userCollections: PHFetchResult<PHAssetCollection>
    var firstImageArray: [UIImage] = []
    var albumNameArrary: [String] = []
    let imgManager = PHImageManager.default()
    let fetchOptions = PHFetchOptions()
    
}
