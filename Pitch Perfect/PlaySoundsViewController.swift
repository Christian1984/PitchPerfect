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
    
    var audioPlayer: AVAudioPlayer!
    var recordedAudio: RecordedAudio?
    
    var audioRatePitch: AVAudioUnitTimePitch!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioFile: AVAudioFile!
    
    //let HelloWorldSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("helloWorld", ofType: "wav")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //if let HelloWorldSound = NSBundle.mainBundle().pathForResource("helloWorld", ofType: "wav")
//        {
//            //println("HelloWorldSound: \(HelloWorldSound)")
//            
//            if let hwsUrl = NSURL(fileURLWithPath: HelloWorldSound)
//            {
//                var error:NSError?
//                audioPlayer = AVAudioPlayer(contentsOfURL: hwsUrl, error: &error)
//                audioPlayer.enableRate = true
//            }
//        }
//        else
//        {
//            println("WARNING: Resource not found!")
//        }
        
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
    
    @IBAction func slowPlay(sender: UIButton) {
        //playAudioAtSpeed(0.5)
        playAudioAtRateAndPitch(0.5, pitch: 1.0)
    }

    @IBAction func fastPlay(sender: UIButton) {
        //playAudioAtSpeed(2.0)
        playAudioAtRateAndPitch(2.0, pitch: 1.0)
    }
    
    @IBAction func highPitchPlay(sender: UIButton) {
        playAudioAtRateAndPitch(1.5, pitch: 800)
    }
    
    @IBAction func lowPitchPlay(sender: UIButton) {
        playAudioAtRateAndPitch(1.0, pitch: -1000)
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
    
    @IBAction func stopPlay(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        
        audioPlayerNode.stop()
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
