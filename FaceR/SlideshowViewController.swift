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
        if time > minimumTime {
            if imageIndex == album.fullAlbum.count - 1 {
                album.timesArray.append(time)
                performSegue(withIdentifier: "swipeLeftSegue", sender: UISwipeGestureRecognizer())
            } else if imageIndex < album.fullAlbum.count && imageIndex != album.fullAlbum.count - 1 {
                print("Swiped left")
                imageIndex += 1
                print(imageIndex)
                album.timesArray.append(time)
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
    
    @objc func action() {
        time += 1
        print("timer is at \(time)")
    }
    
    func initializeCamera() {
        self.captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        let discovery = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified) as AVCaptureDevice.DiscoverySession
        
        for device in discovery.devices as [AVCaptureDevice] {
            
            if device.hasMediaType(AVMediaType.video) {
                if device.position == AVCaptureDevice.Position.front {
                    self.videoCaptureDevice = device
                }
            }
        }
        
        if videoCaptureDevice != nil {
            
            do {
                try self.captureSession.addInput(AVCaptureDeviceInput(device: self.videoCaptureDevice!))
                    
                if let audioInput = AVCaptureDevice.default(for: AVMediaType.audio) {
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
        self.movieFileOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait
        
        self.movieFileOutput.startRecording(to: URL(fileURLWithPath: self.videoFileLocation()), recordingDelegate: self)
    }
    
    // MARK: - AVCaptureFileOutputDelegate
    
    func fileOutput(_ captureOutput: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("Finishedrecord: \(outputFileURL)")
        
        self.outputFileLocation = outputFileURL
        self.performSegue(withIdentifier: "swipeLeftSegue", sender: nil)
        
    }
    
//     MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let preview = segue.destination as! EndOfSlideshowViewController
        preview.fileLocation = self.outputFileLocation
    }
    
    // MARK: - Properties
   
    @IBOutlet var nextPhotoGesture: UISwipeGestureRecognizer!
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
    var outputFileLocation: URL?
    
}
