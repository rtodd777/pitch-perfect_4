//
//  RecordSoundsViewController.swift
//  Pitch Perfect v1
//
//  Created by Todd Stephens on 6/9/15.
//  Copyright (c) 2015 Todd Stephens. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var lblRecording: UILabel!
    @IBOutlet weak var lblTaptoRecord: UILabel!
    @IBOutlet weak var btnStopRecording: UIButton!

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    
    // Click on Record Button
    // --------------------------------------------------------
    @IBAction func btnRecord(sender: UIButton) {
        lblRecording.hidden = false
        lblTaptoRecord.hidden = true
        btnStopRecording.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "myAudio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    // Click on Stop Button
    // --------------------------------------------------------
    @IBAction func btnStopAudio(sender: UIButton) {
        audioRecorder.stop()
        resetScreen()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
    // Audio Finsihed Recording
    // --------------------------------------------------------
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording Failed")
         }
        
    }
    
    // Reset Screen Function
    // --------------------------------------------------------
    func resetScreen() {
        lblRecording.hidden = true
        lblTaptoRecord.hidden = false
        btnStopRecording.hidden = true
    }
    
    
    
    // Prepare for Seque
    // --------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
    
    
    // View will Appear
    // --------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        resetScreen()
    }
    
    
    
    
    // View Did Load
    // --------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // Memory Warning
    // --------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

