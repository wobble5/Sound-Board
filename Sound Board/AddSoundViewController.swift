//
//  AddSoundViewController.swift
//  Sound Board
//
//  Created by Trent Stevens on 29/07/17.
//  Copyright © 2017 Trent Stevens. All rights reserved.
//

import UIKit
import AVFoundation

class AddSoundViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupRecorder()
        
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder() {
        
        do{
            //Create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //Create URL for audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
           
            
            //Create settings for the AudioRecorder
            var settings : [String : AnyObject] = [:]
            settings[AVFormatIDKey] = kAudioFormatMPEG4AAC as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
            
            // Create AudioRecorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        } catch let error as NSError{
            print(error)
        }
    }

    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            //stop the recording
            audioRecorder?.stop()
            
            //change the button text to record
            recordButton.setTitle("Record", for: .normal)
            
            playButton.isEnabled = true
            addButton.isEnabled = true
            
        } else{
            //start the recording
            audioRecorder?.record()
            
            //change the button text to stop
            recordButton.setTitle("Stop", for: .normal)
            
            playButton.isEnabled = false
            
        }
    }

    @IBAction func playTapped(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        } catch{}
        
    }

    @IBAction func addTapped(_ sender: Any) {
        
        let theContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: theContext)
        
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController?.popViewController(animated: true)
        
    }
}
