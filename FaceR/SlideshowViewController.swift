//
//  SlideshowViewController.swift
//  FaceR
//
//  Created by Jordan Fraughton on 7/17/17.
//  Copyright © 2017 Jordan Fraughton. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class SlideshowViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageIndex = 0
        updateViews(index: imageIndex)
        self.SlideshowImageView?.isUserInteractionEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SlideshowViewController.action), userInfo: nil, repeats: true)
        nextViewSwipeGesture.isEnabled = false
        
        // Initialize Camera
        
        self.initializeCamera()
        print("Capture session is running: \(captureSession.isRunning)")
        
        // Start Recording 
        
        self.startRecording()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        self.movieFileOutput.stopRecording()
    }
    
    // MARK: - Swipe Gestures
    
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
                if imageIndex == album.fullAlbum.count - 1 {
                    nextViewSwipeGesture.isEnabled = true
                }
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
    
    // MARK: Main
    
    private func updateViews(index: Int) {
        album.fetchFullAlbumWith(index: album.index)
        SlideshowImageView.image = album.fullAlbum[index]
        navigationItem.title = "Slide \(index + 1) of \(album.fullAlbum.count)"
    }
    
    func action() {
        time += 1
        print("timer is at \(time)")
    }
    
    func initializeCamera() {
        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let discovery = AVCaptureDeviceDiscoverySession.init(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified) as AVCaptureDeviceDiscoverySession
        
        for device in discovery.devices as [AVCaptureDevice] {
            
            if device.hasMediaType(AVMediaTypeVideo) {
                if device.position == AVCaptureDevicePosition.front {
                    self.videoCaptureDevice = device
                }
            }
        }
        
        if videoCaptureDevice != nil {
            
            do {
                try self.captureSession.addInput(AVCaptureDeviceInput(device: self.videoCaptureDevice))
                    
                if let audioInput = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio) {
                    try self.captureSession.addInput(AVCaptureDeviceInput(device: audioInput))
                }
                
                self.captureSession.addOutput(self.movieFileOutput)
                
                self.captureSession.startRunning()
                
            } catch {
                print(error)
            }
        }
    }

    // MARK: Helpers
    
    func videoFileLocation() -> String {
        return NSTemporaryDirectory().appending("videoFile.mov")
    }
    
    func startRecording() {
        self.movieFileOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = .portrait
        
        self.movieFileOutput.startRecording(toOutputFileURL: URL(fileURLWithPath: self.videoFileLocation()), recordingDelegate: self)
    }
    
    // MARK: - AVCaptureFileOutputDelegate
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("Finishedrecord: \(outputFileURL)")
    }
    
    
    // MARK: - Properties
   
    @IBOutlet weak var SlideshowImageView: UIImageView!
    @IBOutlet var nextViewSwipeGesture: UISwipeGestureRecognizer!
    
    let minimumTime = Settings.shared.timerCount
    var imageIndex: Int = 0
    let album = Album.shared
    var time = 0
    var timer = Timer()
    
    // Video
    
    let captureSession = AVCaptureSession()
    var videoCaptureDevice: AVCaptureDevice?
    var movieFileOutput = AVCaptureMovieFileOutput()
    var outputFileURL: URL?
}
