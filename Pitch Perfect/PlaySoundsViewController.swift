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
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    
    var audioPlayer: AVAudioPlayer!
    var recordedAudio: RecordedAudio?
    
    var audioRatePitch: AVAudioUnitTimePitch!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recordedAudio != nil
        {
            println("!!!good!!!")
            
            let audioUrl = recordedAudio!.getFilePathUrl()
            audioPlayer = AVAudioPlayer(contentsOfURL: audioUrl, error: nil)
            audioPlayer.enableRate = true
            
            println("INFO: Resource found at -> \(audioUrl); duration: \(audioPlayer.duration)")
            
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
    @IBAction func slowPlay(sender: UIButton) {
        speedSlider.value = 0.5
        playAudioWithSliderSettings()
    }

    @IBAction func fastPlay(sender: UIButton) {
        speedSlider.value = 2.0
        playAudioWithSliderSettings()
    }
    
    @IBAction func highPitchPlay(sender: UIButton) {
        pitchSlider.value = 800
        playAudioWithSliderSettings()
    }
    
    @IBAction func lowPitchPlay(sender: UIButton) {
        pitchSlider.value = -1000
        playAudioWithSliderSettings()
    }
    
    @IBAction func stopPlay(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        
        audioPlayerNode.stop()
    }
    
    @IBAction func playAudio(sender: AnyObject) {
        playAudioWithSliderSettings()
    }
    
    @IBAction func setSpeed(sender: UISlider) {
        println("Speed \(sender.value)")
        audioRatePitch.rate = sender.value
    }
    
    @IBAction func setPitch(sender: UISlider) {
        println("Pitch \(sender.value)")
        audioRatePitch.pitch = sender.value
    }
    
    
    //custom functions
    func playAudioWithSliderSettings() {
        playAudioAtRateAndPitch(speedSlider.value, pitch: pitchSlider.value)
    }
    
    func playAudioAtRateAndPitch(rate: Float, pitch: Float) {
        audioRatePitch.pitch = pitch
        audioRatePitch.rate = rate
        
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioPlayerNode.play()
    }
    
    func playAudioAtSpeed(speed: Float) {
        audioPlayer.stop()
        audioPlayer.rate = speed
        
        audioPlayer.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
