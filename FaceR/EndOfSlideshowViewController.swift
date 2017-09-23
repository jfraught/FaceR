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
        print("FileLocation = nil : \(fileLocation == nil)")
        saveWithImages()
        navigationController?.popToRootViewController(animated: true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }

    // MARK: Main 
    
    func saveWithImages() {
        
        let composition = AVMutableComposition()
        let asset = AVURLAsset(url: self.fileLocation!)
        
        let track = asset.tracks(withMediaType: AVMediaType.video)
        let videoTrack: AVAssetTrack = track[0] as AVAssetTrack
        let timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration)
        
        let compositionVideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())!
        
        do {
            try compositionVideoTrack.insertTimeRange(timeRange, of: videoTrack, at: kCMTimeZero)
            
            compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        } catch {
            print(error)
        }
        
        // TODO: use switch to choose to add audio or not.
        
        let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
        
        for audioTrack in asset.tracks(withMediaType: AVMediaType.audio) {
            do {
                try compositionAudioTrack.insertTimeRange(audioTrack.timeRange, of: audioTrack, at: kCMTimeZero)
            } catch {
                print(error)
            }
        }
        
        let size = videoTrack.naturalSize
        let image: UIImage = Album.shared.fullAlbum[0]
        let imageLayer = CALayer()
        imageLayer.contents = image.cgImage
        imageLayer.frame = CGRect(x: 10, y:10, width: 180, height: 180)
        
        let videoLayer = CALayer()
        
        videoLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(imageLayer)
        
        let layerComposition = AVMutableVideoComposition()
        layerComposition.frameDuration = CMTimeMake(1, 30)
        layerComposition.renderSize = size
        layerComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
        let videotrack = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
        
        // Transform
        
        let transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))
        layerInstruction.setTransform(transform, at: kCMTimeZero)
        
        instruction.layerInstructions = [layerInstruction]
        layerComposition.instructions = [instruction]
        
        let filePath = NSTemporaryDirectory() + self.fileName()
        let movieUrl = URL(fileURLWithPath: filePath)
        
        guard let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else { return }
        assetExport.videoComposition = layerComposition
        assetExport.outputFileType = AVFileType.mp4
        assetExport.outputURL = movieUrl
        assetExport.exportAsynchronously(completionHandler: {
            switch assetExport.status {
            case .completed:
                print("success")
                PhotoManager().saveVideoToUserLibrary(fileUrl: assetExport.outputURL!) { (success, error) in
                    if success {
                        print("File saved to photos")
                    } else {
                        print("File not saved to photos")
                    }
                }
                break
            case .cancelled:
                print("cancelled")
                break
            case .exporting:
                print("exporting")
                break
            case .failed:
                print("failed: \(String(describing: assetExport.error))")
                break
            case .unknown:
                print("unknown")
                break
            case .waiting:
                print("waiting")
                break
            }
        })
        

    }
    
    // MARK: Helpers 
    
    func fileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddyyhhmmss"
        return formatter.string(from: Date()) + ".mp4"
    }
    
    // MARK: Properties 
    
    let album = Album.shared.fullAlbum
    var fileLocation: URL?
    var newUrl: URL?
}
