//
//  PhotoAlbumsCollectionViewController.swift
//  FaceR
//
//  Created by Jordan Fraughton on 5/20/17.
//  Copyright © 2017 Jordan Fraughton. All rights reserved.
//

import UIKit
import Photos

class PhotosAlbumsCollectionViewController: UICollectionViewController {
    
    // MARK: - Propeties 
    var firstImageArray: [UIImage] = []
    var albumNameArrary: [String] = []
    let imgManager = PHImageManager.default()
    let fetchOptions = PHFetchOptions()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFirstImageFromUserCollections()
    }
    
    func fetchFirstImageFromUserCollections() {
        
        let userCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: PHFetchOptions())
        print(userCollections.count)
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        // Loop through user collections and take the first image of each collection and append it to the array.
        
        if userCollections.count > 0 {
            
            for i in 0..<userCollections.count {
            
                let album = userCollections.object(at: i)
                
                guard let firstImageAsset = PHAsset.fetchAssets(in: album, options: PHFetchOptions()).firstObject else { return }
                
                // firstImage: UIImage
            
               imgManager.requestImage(for: firstImageAsset, targetSize: CGSize.init(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler:
                {
                    image, error in
                    
                    if let firstImage = image {
                    self.firstImageArray.append(firstImage)
                    print(self.firstImageArray.count)
                    }
                })
                
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return firstImageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCollectionCell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        imageView.image = firstImageArray[indexPath.row]
        
        return cell
    }
    
}
