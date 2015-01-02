//
//  RecordAudioViewController.swift
//  Pitch Perfect
//
//  Created by Christian Hoffmann on 23.12.14.
//  Copyright (c) 2014 be-amazed. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordInProgress.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        //show text "recording in progress"
        recordInProgress.hidden = false //!recordInProgress.hidden
        stopButton.hidden = false
        
        //disable record button
        recordButton.enabled = false
        
        //---record audio
        // create audioRecorder variable
        //var audioRecorder: AVAudioRecorder!
        
        //build path and filename
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HHmmss"
        let recordingName = formatter.stringFromDate(NSDate()) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println("INFO: filepath = \(filePath)")
        
        //make audio rec available to session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //create recorder and record
        if let audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        {
            self.audioRecorder = audioRecorder
            
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.record()
            
            println("INFO: recording audio")
        }
        else
        {
            println("WARNING: cannot record audio")
        }
        
    }

    @IBAction func stopRecording(sender: UIButton) {
        //stop recording and release session
        if (audioRecorder != nil)
        {
            audioRecorder.stop()
            AVAudioSession.sharedInstance().setActive(false, error: nil)
            
            println("INFO: recording stopped")
        }
        else
        {
            println("WARNING: recording could not be stopped")
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag)
        {
            //step 1 - save recorded audio
            let recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            //step 2 - navigate to second view
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            println("WARNING: Recording not successfull")
            
            recordInProgress.hidden = true
            stopButton.hidden = true
            recordButton.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording")
        {
            let psvc = segue.destinationViewController as PlaySoundsViewController
            psvc.recordedAudio = sender as? RecordedAudio
        }
    }
}

