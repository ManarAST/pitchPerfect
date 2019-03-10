//
// RecordSoundsViewConroller.swift
//  pitchPerfect
//
//  Created by manar on 08/11/2018.
//  Copyright © 2018 manar. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewConroller: UIViewController, AVAudioRecorderDelegate{
    
    var audioRecorder : AVAudioRecorder!

    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLable: UILabel!
    
    
    
    func configurUI(isRecording : Bool) {
        recordingButton.isEnabled = isRecording
        stopRecordingButton.isEnabled = !isRecording
        
        if isRecording {
            audioRecorder.stop()
        } else {
             audioRecorder.record()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func recordAudio(_ sender: Any) {
        configurUI(isRecording: false)
       
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
      
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode:AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
       
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configurUI(isRecording: true)
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("recording faild")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }
}

