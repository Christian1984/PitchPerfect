//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Christian Hoffmann on 29.12.14.
//  Copyright (c) 2014 be-amazed. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var recordedAudio: RecordedAudio?
    
    var audioRatePitch: AVAudioUnitTimePitch!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioFile: AVAudioFile!
    
    @IBOutlet weak var borderView: UIImageView!
    @IBOutlet weak var snailButton: UIImageView!
    @IBOutlet weak var rabbitButton: UIImageView!
    @IBOutlet weak var chipmunkButton: UIImageView!
    @IBOutlet weak var vaderButton: UIImageView!
    @IBOutlet weak var touchPosition: UIImageView!
    
    let MIN_RATE: Float = 0.5
    let MAX_RATE: Float = 2.0
    let MIN_PITCH: Float = -1000
    let MAX_PITCH: Float = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup border for touch area
        borderView.layer.borderColor = UIColor(red: 33/255, green: 73/255, blue: 111/255, alpha: 1.0).CGColor
        borderView.layer.borderWidth = 2.0
        
        if recordedAudio != nil
        {
            println("!!!good!!!")
            
            let audioUrl = recordedAudio!.getFilePathUrl()
            
            //create audio engine and attach pitch-effect and player
            audioEngine = AVAudioEngine()
            audioRatePitch = AVAudioUnitTimePitch()
            audioPlayerNode = AVAudioPlayerNode()
            
            audioEngine.attachNode(audioRatePitch)
            audioEngine.attachNode(audioPlayerNode)
            
            audioEngine.connect(audioPlayerNode, to: audioRatePitch, format: nil)
            audioEngine.connect(audioRatePitch, to: audioEngine.outputNode, format: nil)
            
            audioFile = AVAudioFile(forReading: audioUrl, error: nil)
            
            audioEngine.startAndReturnError(nil)
        }
        else
        {
            println("WARNING: Resource not found!")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //actions
    @IBAction func stopPlay(sender: UIButton) {
        audioPlayerNode.stop()
    }
    
    @IBAction func playAudio(sender: AnyObject) {
        playAudio()
    }
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        println("Tapping: \(sender.locationInView(self.view))")
        updateOnUserInput(sender.locationInView(self.view))
    }
    
    @IBAction func viewDragged(sender: UIPanGestureRecognizer) {
        if sender.state == .Changed
        {
            println("Dragging: \(sender.locationInView(self.view))")
            updateOnUserInput(sender.locationInView(self.view))
        }
    }
    
    //custom functions
    func updateOnUserInput(position: CGPoint) {
        var x = position.x
        var y = position.y
        if (coordinateInsideButtonRect(x, y: y)) {
            touchPosition.center.x = x
            touchPosition.center.y = y
            
            let pitch = getPitchValueFromTouchLocation(Float(x))
            let rate = getRateValueFromTouchLocation(Float(y))
            
            println("Pitch: \(pitch)")
            println("Rate: \(rate)")
            
            audioRatePitch.pitch = pitch
            audioRatePitch.rate = rate
        }
    }
    
    func coordinateInsideButtonRect(x: CGFloat, y: CGFloat) -> Bool {
        if ((x < borderView.center.x - borderView.frame.size.width / 2) || (y < borderView.center.y - borderView.frame.size.height / 2) || (x > borderView.center.x + borderView.frame.size.width / 2) || (y > borderView.center.y + borderView.frame.size.height / 2)) {
            return false
        }
        
        return true
    }
    
    func getPitchValueFromTouchLocation(x: Float) -> Float {
        let MIN_PITCH: Float = -1000
        let MAX_PITCH: Float = 1000
        
        let X_MIN = Float(borderView.center.x - borderView.frame.size.width / 2)
        let X_MAX = Float(borderView.center.x + borderView.frame.size.width / 2)
        
        return remapToInterval(MIN_PITCH, targetHigh: MAX_PITCH, srcLow: X_MIN, srcHigh: X_MAX, srcValue: x)
    }
    
    func getRateValueFromTouchLocation(y: Float) -> Float {
        let MIN_RATE: Float = 0.5
        let MAX_RATE: Float = 2.0
        
        let Y_MIN = Float(borderView.center.y - borderView.frame.size.height / 2)
        let Y_MAX = Float(borderView.center.y + borderView.frame.size.height / 2)
        
        return remapToInterval(MIN_RATE, targetHigh: MAX_RATE, srcLow: Y_MIN, srcHigh: Y_MAX, srcValue: y)
    }
    
    func remapToInterval(targetLow: Float, targetHigh: Float, srcLow: Float, srcHigh: Float, srcValue: Float) -> Float {
        return (targetLow - targetHigh) * (srcValue - srcHigh) / (srcLow - srcHigh) + targetHigh
    }
    
    func playAudio() {
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioPlayerNode.play()
    }
}
