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
    static let shared = Album()
   
    var firstImageArray: [UIImage] = []
    var albumNameArrary: [String] = []
    let imgManager = PHImageManager.default()
    let fetchOptions = PHFetchOptions()
    
    
    
    func fetchFirstImageFromUserCollections() {
        
        // Get user collections
        
        let userCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: PHFetchOptions())
        print(userCollections.count)
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

}
