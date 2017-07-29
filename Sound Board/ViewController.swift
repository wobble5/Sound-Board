//
//  ViewController.swift
//  Sound Board
//
//  Created by Trent Stevens on 29/07/17.
//  Copyright © 2017 Trent Stevens. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var soundTableView: UITableView!
    
    var sounds : [Sound] = []
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        soundTableView.delegate = self
        soundTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
        try sounds = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(Sound.fetchRequest())
        } catch{}
        soundTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        
        do {
            try audioPlayer = AVAudioPlayer(data: sound.audio! as Data)
            audioPlayer?.play()
        } catch{}
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.delete(sound)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        soundTableView.reloadData()
        
    }
}

